# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/huangyifei/Library/Android/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}


-keep class com.github.mikephil.charting.** { *; }
-dontwarn io.realm.**
# Flutter's main entry point and JNI methods must be kept
-keep class com.maitechno.mVpn.MainActivity { *; }
-keep public class io.flutter.app.FlutterApplication { *; }
-keep public class io.flutter.plugin.common.MethodChannel { *; }
-keep public class io.flutter.plugin.common.EventChannel { *; }

# Keep all classes in the de.blinkt.openvpn library
# This is a broad but safe rule to prevent any part of the VPN library from being removed or renamed.
-keep class de.blinkt.openvpn.** { *; }
-keep interface de.blinkt.openvpn.** { *; }

# Standard Flutter rules (good to have if they aren't already there)
-keep class io.flutter.plugins.** { *; }