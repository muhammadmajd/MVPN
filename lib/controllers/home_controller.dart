import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/ad_helper.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';
import 'location_controller.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;
  final locationController = Get.find<LocationController>();
  // Add this to track random connection attempts
  final RxBool isConnectingRandom = false.obs;
  final RxInt currentAttempt = 0.obs;
  final RxInt totalAttempts = 0.obs;
  final Random _random = Random();
  List<Vpn> _availableServers = [];

  // Timer for connection timeout
  Timer? _connectionTimer;

  @override
  void onInit() {
    super.onInit();
    // Listen to VPN state changes for random connection logic
    ever(vpnState, (state) {
      _handleVpnStateChange(state);
    });
  }

  @override
  void onClose() {
    // Clean up timer when controller is closed
    _connectionTimer?.cancel();
    super.onClose();
  }

  void connectToVpn() async {
    if (vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(msg: 'Select a Location by clicking \'Change Location\'');
      return;
    }


    if (vpnState.value == VpnEngine.vpnDisconnected) {
      await _startVpnConnection(vpn.value);
    } else {
      await VpnEngine.stopVpn();
    }
  }

  // New function: Connect to random servers until successful
  void connectToRandomVpn() async {
    if (isConnectingRandom.value) {
      // If already connecting randomly, stop the process
      _stopRandomConnection();
      MyDialogs.info(msg: ' connection attempt stopped');
      return;
    }

    // Get the location controller
    final locationController = Get.find<LocationController>();
    _availableServers = List.from(locationController.getVpnList());

    if (_availableServers.isEmpty) {
      MyDialogs.error(msg: 'No VPN servers available');
      return;
    }

    // Filter out servers with empty configs
    _availableServers = _availableServers.where((server) =>
    server.openVPNConfigDataBase64.isNotEmpty).toList();

    if (_availableServers.isEmpty) {
      MyDialogs.error(msg: 'No VPN servers with valid configuration');
      return;
    }

    isConnectingRandom.value = true;
    currentAttempt.value = 0;
    totalAttempts.value = _availableServers.length;

    MyDialogs.info(msg: 'Starting  VPN connection attempts...');

    // Start with a random server
    await _tryRandomServer();
  }

  Future<void> _tryRandomServer() async {
    if (!isConnectingRandom.value || _availableServers.isEmpty) return;
    await locationController.getVpnData();
    currentAttempt.value++;

    // Define specific countries to test only as last resort
    final lastResortCountries = ['japan','russian federation', 'Russia'];

    // Separate servers: regular servers vs last resort servers
    List<Vpn> regularServers = _availableServers.where((server) =>
    !lastResortCountries.contains(server.countryLong.toLowerCase())
    ).toList();

    List<Vpn> lastResortServers = _availableServers.where((server) =>
        lastResortCountries.contains(server.countryLong.toLowerCase())
    ).toList();

    Vpn selectedServer;

    // Strategy: Use regular servers first, only use last resort when no regular servers left
    if (regularServers.isNotEmpty) {
      // Pick random from regular servers
      final randomIndex = _random.nextInt(regularServers.length);
      selectedServer = regularServers[randomIndex];
    } else if (lastResortServers.isNotEmpty) {
      // Only use Russia/Japan when all other countries are exhausted
      final randomIndex = _random.nextInt(lastResortServers.length);
      selectedServer = lastResortServers[randomIndex];
    } else {
      // No servers left at all
      _stopRandomConnection();
      MyDialogs.error(msg: 'No more servers available to try');
      return;
    }

    // Remove selected server from available list
    _availableServers.remove(selectedServer);

    // Show appropriate message based on server type
    if (lastResortCountries.contains(selectedServer.countryLong.toLowerCase())) {
     // MyDialogs.info(msg: 'Attempt $currentAttempt/$totalAttempts: Trying ${selectedServer.countryLong} (Last Resort)');
    } else {
     // MyDialogs.info(msg: 'Attempt $currentAttempt/$totalAttempts: Trying ${selectedServer.countryLong}');
    }

    // Update current VPN and start connection
    vpn.value = selectedServer;
    Pref.vpn = selectedServer;

    // Start connection timeout timer (10 seconds)
    _startConnectionTimer();

    await _startVpnConnection(selectedServer);
  }
  Future<void> _tryRandomServer1() async {
    if (!isConnectingRandom.value || _availableServers.isEmpty) return;

    currentAttempt.value++;

    // Pick a random server
    final randomIndex = _random.nextInt(_availableServers.length);
    final randomServer = _availableServers[randomIndex];

    // Remove this server from available list to avoid retrying immediately
    _availableServers.removeAt(randomIndex);

   // MyDialogs.info(msg: 'Attempt $currentAttempt/$totalAttempts: Trying ${randomServer.countryLong}');

    // Update current VPN and start connection
    vpn.value = randomServer;
    Pref.vpn = randomServer;

    // Start connection timeout timer (10 seconds)
    _startConnectionTimer();

    await _startVpnConnection(randomServer);
  }

  void _startConnectionTimer() {
    // Cancel any existing timer
    _connectionTimer?.cancel();

    // Start new timer for 10 seconds
    _connectionTimer = Timer(Duration(seconds: 10), () {
      if (isConnectingRandom.value && vpnState.value != VpnEngine.vpnConnected) {
        print('Connection timeout - moving to next server');
        _moveToNextServer();
      }
    });
  }

  void _moveToNextServer() {
    if (_availableServers.isNotEmpty) {
      //MyDialogs.info(msg: 'Connection timeout, trying next server...');
      _tryRandomServer();
    } else {
      _stopRandomConnection();
      MyDialogs.error(msg: 'All connection attempts failed (timeout)');
    }
  }

  void _stopRandomConnection() {
    isConnectingRandom.value = false;
    _connectionTimer?.cancel();
    _connectionTimer = null;
  }

  void _handleVpnStateChange(String state) {
    if (!isConnectingRandom.value) return;

    // Cancel timer when connection state changes
    if (state == VpnEngine.vpnConnected || state == VpnEngine.vpnDisconnected) {
      _connectionTimer?.cancel();
    }

    if (state == VpnEngine.vpnConnected) {
      // Success! Stop the random connection process
      _stopRandomConnection();
      MyDialogs.success(msg: 'Successfully connected to ${vpn.value.countryLong}');
    }
    else if (state == VpnEngine.vpnDisconnected && isConnectingRandom.value) {
      // Connection failed, try another server if available
      if (_availableServers.isNotEmpty) {
        // Wait a bit before trying next server
        Future.delayed(Duration(seconds: 1), () {
          if (isConnectingRandom.value) {
            _tryRandomServer();
          }
        });
      } else {
        // No more servers to try
        _stopRandomConnection();
        MyDialogs.error(msg: 'All connection attempts failed');
      }
    }
  }

  Future<void> _startVpnConnection(Vpn server) async {
    try {
      final data = Base64Decoder().convert(server.openVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);

      final vpnConfig = VpnConfig(
        country: server.countryLong,
        username: 'vpn',
        password: 'vpn',
        config: config,
      );

      await VpnEngine.startVpn(vpnConfig);

      /* // Optional: Show interstitial ad
      AdHelper.showInterstitialAd(onComplete: () async {
        await VpnEngine.startVpn(vpnConfig);
      });*/

    } catch (e) {
      MyDialogs.error(msg: 'Connection error: ${e.toString()}');
      if (isConnectingRandom.value) {
        // Trigger state change to try next server
        vpnState.value = VpnEngine.vpnDisconnected;
      }
    }
  }

  // vpn buttons color
  Color get getButtonColor {
    if (isRandomConnectionActive) {
      return Colors.purple;
    }

    switch (vpnState.value) {
      case VpnEngine.vpnConnected:
        return Colors.green;
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      default:
        return Colors.orangeAccent;
    }
  }

  // vpn button text
  String get getButtonText {
    if (isRandomConnectionActive) {
      return ' Connecting';
    }

    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting...';
    }
  }

  // Add a method to check if random connection is active
  bool get isRandomConnectionActive => isConnectingRandom.value;

  // Get current attempt info for UI
  String get attemptInfo => 'Attempt $currentAttempt/$totalAttempts';
}