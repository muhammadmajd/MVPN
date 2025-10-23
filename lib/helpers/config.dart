import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
//https://www.youtube.com/watch?v=XkbRhBiSZMU
class Config {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "interstitial_ad": "ca-app-pub-3940256099942544/1033173712",
    "native_ad": "ca-app-pub-3940256099942544/2247696110",
    "rewarded_ad": "ca-app-pub-3940256099942544/5224354917",
    "show_ads": true
  };
// in config.dart
  static Future<void> initConfig() async {
    final _config = FirebaseRemoteConfig.instance;

    // 1. Set Production Fetch Settings
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    // 2. Set In-App Default Values (your code for this is perfect)
    await _config.setDefaults(_defaultValues);

    // 3. Activate last fetched config, then fetch new for next time
    try {
      // Activate any previously fetched values
      await _config.activate();
      log('Remote Config Activated. show_ads: ${_config.getBool('show_ads')}');

      // Listen for real-time updates (your code for this is also good)
      _config.onConfigUpdated.listen((event) async {
        await _config.activate();
        log('Real-time update activated. show_ads: ${_config.getBool('show_ads')}');
      });

      // Fetch new values for the *next* app launch in the background
      _config.fetch();
    } catch (e) {
      log("RemoteConfig fetch/activate failed: $e");
      // App will continue using defaults or the last activated values
    }
  }
  static Future<void> initConfig1() async {
    // SETTINGS FOR TESTING - Fetches very frequently, minimal caching
    await _config.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5)));


    // SETTINGS FOR PRODUCTION - Respects caching, default intervals
    /*await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1), // Reasonable timeout
      minimumFetchInterval: const Duration(hours: 1), // Sensible default, can be up to 12 hours
    ));
*/
    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
    log('Remote Config Data: ${_config.getBool('show_ads')}');

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log('Updated: ${_config.getBool('show_ads')}');
    });
  }

  static bool get _showAd => _config.getBool('show_ads');

  //ad ids
  static String get nativeAd => _config.getString('native_ad');
  static String get interstitialAd => _config.getString('interstitial_ad');
  static String get rewardedAd => _config.getString('rewarded_ad');

  static bool get hideAds => !_showAd;
}
