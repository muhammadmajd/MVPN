package com.maitechno.mVpn;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.VpnService;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.multidex.MultiDex;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import de.blinkt.openvpn.VpnProfile;
import de.blinkt.openvpn.core.ConfigParser;
import de.blinkt.openvpn.core.OpenVPNService;
import de.blinkt.openvpn.core.OpenVPNThread;
import de.blinkt.openvpn.core.ProfileManager;
import de.blinkt.openvpn.core.VPNLaunchHelper;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    // --- Constants for Channels and Methods ---
    private static final String EVENT_CHANNEL_VPN_STAGE = "vpnStage";
    private static final String EVENT_CHANNEL_VPN_STATUS = "vpnStatus";
    private static final String METHOD_CHANNEL_VPN_CONTROL = "vpnControl";

    private static final String METHOD_START = "start";
    private static final String METHOD_STOP = "stop";
    private static final String METHOD_REFRESH = "refresh";
    private static final String METHOD_REFRESH_STATUS = "refresh_status";
    private static final String METHOD_STAGE = "stage";
    private static final String METHOD_KILL_SWITCH = "kill_switch";

    // --- Constants for VPN Stages (sent to Flutter) ---
    private static final String STAGE_CONNECTED = "connected";
    private static final String STAGE_DISCONNECTED = "disconnected";
    private static final String STAGE_WAIT_CONNECTION = "wait_connection";
    private static final String STAGE_AUTHENTICATING = "authenticating";
    private static final String STAGE_RECONNECTING = "reconnect";
    private static final String STAGE_NO_CONNECTION = "no_connection";
    private static final String STAGE_CONNECTING = "connecting";
    private static final String STAGE_PREPARING = "prepare";
    private static final String STAGE_DENIED = "denied";
    private static final String STAGE_ERROR = "error";

    private static final String TAG = "VPN_PLUGIN";
    private static final int VPN_REQUEST_ID = 1;

    // --- Channel and Sink Objects ---
    private MethodChannel vpnControlMethod;
    private EventChannel vpnStageEvent;
    private EventChannel vpnStatusEvent;
    private EventChannel.EventSink vpnStageSink;
    private EventChannel.EventSink vpnStatusSink;

    // --- VPN Profile and State ---
    private VpnProfile vpnProfile;
    private BroadcastReceiver vpnStateReceiver;
    private boolean attachedToWindow = false;
    private JSONObject lastVpnStatusJson;

    // --- Sensitive Data ---
    // These are cleared after use to improve security.
    private String config = "", username = "", password = "";

    // --- Other VPN Parameters ---
    private String name = "";
    private String dns1 = VpnProfile.DEFAULT_DNS1;
    private String dns2 = VpnProfile.DEFAULT_DNS2;
    private ArrayList<String> bypassPackages;

    // Map OpenVPN internal states to our Flutter stage strings
    private static final Map<String, String> openVpnStateMap = new HashMap<>();
    static {
        openVpnStateMap.put("CONNECTED", STAGE_CONNECTED);
        openVpnStateMap.put("DISCONNECTED", STAGE_DISCONNECTED);
        openVpnStateMap.put("WAIT", STAGE_WAIT_CONNECTION);
        openVpnStateMap.put("AUTH", STAGE_AUTHENTICATING);
        openVpnStateMap.put("RECONNECTING", STAGE_RECONNECTING);
        openVpnStateMap.put("NONETWORK", STAGE_NO_CONNECTION);
        openVpnStateMap.put("CONNECTING", STAGE_CONNECTING);
        openVpnStateMap.put("PREPARE", STAGE_PREPARING);
        openVpnStateMap.put("DENIED", STAGE_DENIED);
    }

    // --- Android Lifecycle Methods ---

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(newBase);
        MultiDex.install(this);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // SECURITY: Prevent screenshots and screen recording of this activity window.
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);

        initializeVpnStatusCache();
        initializeVpnStateReceiver();
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        attachedToWindow = true;
        updateVPNStage(); // Send current stage when UI is ready
        updateVPNStatus(); // Send current status when UI is ready
    }

    @Override
    public void onDetachedFromWindow() {
        attachedToWindow = false;
        super.onDetachedFromWindow();
    }

    @Override
    protected void onDestroy() {
        // Clean up resources to prevent leaks
        if (vpnStateReceiver != null) {
            LocalBroadcastManager.getInstance(this).unregisterReceiver(vpnStateReceiver);
            vpnStateReceiver = null;
        }
        if (vpnStageEvent != null) vpnStageEvent.setStreamHandler(null);
        if (vpnStatusEvent != null) vpnStatusEvent.setStreamHandler(null);
        if (vpnControlMethod != null) vpnControlMethod.setMethodCallHandler(null);

        // Although the service might continue running, clear any local sensitive data.
        clearSensitiveData();
        super.onDestroy();
    }

    // --- Flutter Engine Configuration ---

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        setupEventChannels(flutterEngine);
        setupMethodChannel(flutterEngine);
    }

    private void setupEventChannels(@NonNull FlutterEngine flutterEngine) {
        vpnStageEvent = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL_VPN_STAGE);
        vpnStageEvent.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object args, EventChannel.EventSink events) { vpnStageSink = events; }
            @Override
            public void onCancel(Object args) { vpnStageSink = null; }
        });

        vpnStatusEvent = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL_VPN_STATUS);
        vpnStatusEvent.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object args, EventChannel.EventSink events) {
                vpnStatusSink = events;
                if (lastVpnStatusJson != null) {
                    updateVPNStatus();
                }
            }
            @Override
            public void onCancel(Object args) { vpnStatusSink = null; }
        });
    }

    private void setupMethodChannel(@NonNull FlutterEngine flutterEngine) {
        vpnControlMethod = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL_VPN_CONTROL);
        vpnControlMethod.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case METHOD_START:
                    handleStartVpn(call.argument("config"), call.argument("country"),
                            call.argument("username"), call.argument("password"),
                            call.argument("dns1"), call.argument("dns2"),
                            call.argument("bypass_packages"), result);
                    break;
                case METHOD_STOP:
                    stopVpn();
                    result.success(null);
                    break;
                case METHOD_REFRESH:
                    updateVPNStage();
                    result.success(null);
                    break;
                case METHOD_REFRESH_STATUS:
                    updateVPNStatus();
                    result.success(null);
                    break;
                case METHOD_STAGE:
                    result.success(OpenVPNService.getStatus());
                    break;
                case METHOD_KILL_SWITCH:
                    openKillSwitchSettings(result);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    // --- VPN Logic Methods ---

    private void handleStartVpn(String config, String country, String username, String password,
                                String dns1, String dns2, ArrayList<String> bypassPackages,
                                @NonNull MethodChannel.Result result) {
        this.config = config;
        this.name = country;
        this.username = username;
        this.password = password;
        this.dns1 = Objects.toString(dns1, VpnProfile.DEFAULT_DNS1);
        this.dns2 = Objects.toString(dns2, VpnProfile.DEFAULT_DNS2);
        this.bypassPackages = bypassPackages;

        if (this.config == null || this.config.isEmpty() || this.name == null || this.name.isEmpty()) {
            Log.e(TAG, "VPN start request failed: Config or name is missing.");
            setStage(STAGE_ERROR);
            result.error("INVALID_ARGUMENTS", "Config or country name cannot be null or empty.", null);
            return;
        }

        if (!isConnected()) {
            setStage(STAGE_NO_CONNECTION);
            result.error("NO_NETWORK", "No active network connection.", null);
            return;
        }

        try {
            prepareVpnProfile();
            result.success(null); // Acknowledge successful preparation
        } catch (IOException | ConfigParser.ConfigParseError e) {
            Log.e(TAG, "Error parsing VPN config", e);
            setStage(STAGE_ERROR);
            result.error("CONFIG_PARSE_ERROR", "Failed to parse OVPN configuration.", e.getMessage());
        }
    }


    private void prepareVpnProfile() throws IOException, ConfigParser.ConfigParseError {
        setStage(STAGE_PREPARING);
        ConfigParser configParser = new ConfigParser();
        configParser.parseConfig(new StringReader(this.config));
        vpnProfile = configParser.convertProfile();
        vpnProfile.mName = this.name;

        int profileCheckResult = vpnProfile.checkProfile(this);
        if (profileCheckResult != de.blinkt.openvpn.R.string.no_error_found) {
            String errorMsg = getString(profileCheckResult);
            Log.e(TAG, "VPN Profile Check Failed: " + errorMsg);
            throw new ConfigParser.ConfigParseError(errorMsg);
        }

        Intent vpnIntent = VpnService.prepare(this);
        if (vpnIntent != null) {
            startActivityForResult(vpnIntent, VPN_REQUEST_ID);
        } else {
            // Permission already granted, proceed directly.
            onActivityResult(VPN_REQUEST_ID, RESULT_OK, null);
        }
    }


    private void startVPN() {
        if (vpnProfile == null) {
            Log.e(TAG, "VPN Profile is null, cannot start VPN.");
            setStage(STAGE_ERROR);
            return;
        }

        setStage(STAGE_CONNECTING);

        // Populate the profile with dynamic and user-provided details.
        vpnProfile.mProfileCreator = getPackageName();
        vpnProfile.mUsername = this.username;
        vpnProfile.mPassword = this.password;
        vpnProfile.mDNS1 = this.dns1;
        vpnProfile.mDNS2 = this.dns2;
        vpnProfile.mOverrideDNS = !Objects.equals(this.dns1, VpnProfile.DEFAULT_DNS1) ||
                !Objects.equals(this.dns2, VpnProfile.DEFAULT_DNS2);

        vpnProfile.mAllowedAppsVpn.clear();
        if (bypassPackages != null && !bypassPackages.isEmpty()) {
            vpnProfile.mAllowedAppsVpn.addAll(bypassPackages);
            vpnProfile.mAllowAppVpnBypass = true;
        } else {
            vpnProfile.mAllowAppVpnBypass = false;
        }

        // SECURITY: Use a temporary profile. This avoids writing the profile with sensitive
        // details (like keys from the .ovpn) to permanent storage.
        ProfileManager.setTemporaryProfile(this, vpnProfile);
        VPNLaunchHelper.startOpenVpn(vpnProfile, this);

        // SECURITY: Clear sensitive data from memory now that it has been handed to the VPN service.
        clearSensitiveData();
    }


    private void stopVpn() {
        OpenVPNThread.stop();
        // SECURITY: Clear any lingering sensitive data on explicit stop.
        clearSensitiveData();
        // The broadcast receiver will call setStage(STAGE_DISCONNECTED) upon successful disconnection.
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == VPN_REQUEST_ID) {
            if (resultCode == RESULT_OK) {
                startVPN();
            } else {
                setStage(STAGE_DENIED);
                Toast.makeText(this, "VPN Permission denied by user.", Toast.LENGTH_SHORT).show();
            }
        }
    }


    // --- Helper and Utility Methods ---

    /**
     * SECURITY: Nullifies sensitive data in memory to reduce the chance of it being compromised.
     */
    private void clearSensitiveData() {
        this.config = null;
        this.username = null;
        this.password = null;
        // The VpnProfile object in memory will be garbage collected when no longer referenced.
        // We avoid keeping a long-lived reference to it.
    }


    private void setStage(String stage) {
        if (vpnStageSink != null && attachedToWindow) {
            vpnStageSink.success(stage);
        } else {
            Log.d(TAG, "VPN Stage Sink not ready or activity not attached. Stage: " + stage);
        }
    }


    private void updateVPNStage() {
        String currentStatus = OpenVPNService.getStatus();
        setStage(openVpnStateMap.getOrDefault(
                currentStatus != null ? currentStatus.toUpperCase() : "DISCONNECTED",
                STAGE_DISCONNECTED
        ));
    }


    private void updateVPNStatus() {
        if (vpnStatusSink != null && attachedToWindow && lastVpnStatusJson != null) {
            vpnStatusSink.success(lastVpnStatusJson.toString());
        }
    }


    private boolean isConnected() {
        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        if (cm == null) return false;
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
    }


    private void openKillSwitchSettings(MethodChannel.Result result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            try {
                Intent intent = new Intent(Settings.ACTION_VPN_SETTINGS);
                startActivity(intent);
                result.success(null);
            } catch (Exception e) {
                Log.e(TAG, "Could not open VPN settings", e);
                result.error("SETTINGS_ERROR", "Could not open VPN settings.", e.getMessage());
            }
        } else {
            Toast.makeText(this, "Kill switch settings not directly available on this Android version.", Toast.LENGTH_LONG).show();
            result.success(null); // Indicate success as the action was handled (by showing a toast).
        }
    }


    private void initializeVpnStatusCache() {
        lastVpnStatusJson = new JSONObject();
        try {
            lastVpnStatusJson.put("duration", "00:00:00");
            lastVpnStatusJson.put("last_packet_receive", "0");
            lastVpnStatusJson.put("byte_in", " ");
            lastVpnStatusJson.put("byte_out", " ");
        } catch (JSONException e) {
            Log.e(TAG, "Error initializing lastVpnStatusJson", e);
        }
    }


    private void initializeVpnStateReceiver() {
        vpnStateReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                // Update VPN stage
                String state = intent.getStringExtra("state");
                if (state != null) {
                    setStage(openVpnStateMap.getOrDefault(state.toUpperCase(), STAGE_ERROR));
                }

                // Update VPN connection status (bytes, duration)
                if (vpnStatusSink != null) {
                    try {
                        JSONObject currentStatus = new JSONObject();
                        currentStatus.put("duration", intent.getStringExtra("duration"));
                        currentStatus.put("last_packet_receive", intent.getStringExtra("lastPacketReceive"));
                        currentStatus.put("byte_in", intent.getStringExtra("byteIn"));
                        currentStatus.put("byte_out", intent.getStringExtra("byteOut"));
                        lastVpnStatusJson = currentStatus; // Cache the latest status
                        updateVPNStatus(); // Send to Flutter
                    } catch (Exception e) {
                        Log.e(TAG, "Error processing VPN status update", e);
                    }
                }
            }
        };
        LocalBroadcastManager.getInstance(this).registerReceiver(vpnStateReceiver, new IntentFilter("connectionState"));
    }
}