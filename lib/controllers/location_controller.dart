// controllers/location_controller.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../apis/apis.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';

enum SortType { score, country, speed, ping }

class LocationController extends GetxController {
  List<Vpn> _originalVpnList = Pref.vpnList; // Store the original fetched list
  RxList<Vpn> vpnList = RxList<Vpn>(); // This will be the displayed/filtered list

  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortType> currentSortType = SortType.score.obs; // Default sort

  @override
  void onInit() {
    super.onInit();
    getVpnData();
    // Initialize vpnList with the original list
    vpnList.assignAll(_originalVpnList);
    // Apply initial sort and filter
    _applyFiltersAndSort();

    // Listen to changes for reactive updates
    ever(searchQuery, (_) => _applyFiltersAndSort());
    ever(currentSortType, (_) => _applyFiltersAndSort());
  }
  List<Vpn> getVpnList() {
    return _originalVpnList;
  }
  Future<void> getVpnData() async {
    isLoading.value = true;
    _originalVpnList = await APIs.getVPNServers();
    Pref.vpnList = _originalVpnList; // Update preferences
    _applyFiltersAndSort(); // Apply current filters and sort to the new data
    isLoading.value = false;
  }

  void _applyFiltersAndSort() {
    List<Vpn> tempList = List.from(_originalVpnList); // Work with a copy

    // Apply Search Filter
    if (searchQuery.value.isNotEmpty) {
      tempList = tempList.where((vpn) {
        final query = searchQuery.value.toLowerCase();
        return vpn.countryLong.toLowerCase().contains(query) ||
            vpn.countryShort.toLowerCase().contains(query) ||
            vpn.hostname.toLowerCase().contains(query) || // Optional: search by hostname
            vpn.ip.toLowerCase().contains(query);         // Optional: search by IP
      }).toList();
    }

    // Apply Sort
    switch (currentSortType.value) {
      case SortType.score:
        tempList.sort((a, b) => b.score.compareTo(a.score)); // Higher score first
        break;
      case SortType.country:
        tempList.sort((a, b) => a.countryLong.compareTo(b.countryLong));
        break;
      case SortType.speed:
        tempList.sort((a, b) => b.speed.compareTo(a.speed)); // Higher speed first
        break;
      case SortType.ping:
        tempList.sort((a, b) {
          // Treat invalid pings (0 or very high) as worse
          int pingA = (a.ping <= 0 || a.ping > 9000) ? 9999 : a.ping;
          int pingB = (b.ping <= 0 || b.ping > 9000) ? 9999 : b.ping;
          return pingA.compareTo(pingB); // Lower ping first
        });
        break;
    }
    vpnList.assignAll(tempList); // Update the reactive list
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSortType(SortType sortType) {
    currentSortType.value = sortType;
  }

  Vpn? getAutoOptimalServer() {

    if (_originalVpnList.isEmpty) return null;

    List<Vpn> tempList = List.from(_originalVpnList);

    // *** DEBUG LOGGING: Print the top 5 servers before sorting ***
    print('--- Top 5 Servers Before Sorting ---');
    for (var i = 0; i < 5 && i < tempList.length; i++) {
      final vpn = tempList[i];
      print('Country: ${vpn.countryLong}, Speed: ${vpn.speed}, Ping: ${vpn.ping}, Score: ${vpn.score}');
    }
    // ******************************************************

    // 2. Higher Speed
    // 3. Lower Ping
    // 4. Higher Score
    tempList.sort((a, b) {
      // Primary sort: Speed (descending)
      int speedCompare = b.speed.compareTo(a.speed);
      if (speedCompare != 0) return speedCompare;

      // Secondary sort: Ping (ascending, normalize invalid pings)
      int pingA = (a.ping <= 0 || a.ping > 9000) ? 9999 : a.ping;
      int pingB = (b.ping <= 0 || b.ping > 9000) ? 9999 : b.ping;
      int pingCompare = pingA.compareTo(pingB);
      if (pingCompare != 0) return pingCompare;

      // Tertiary sort: Score (descending)
      return b.score.compareTo(a.score);
    });

    // *** DEBUG LOGGING: Print the top server AFTER sorting ***
    if (tempList.isNotEmpty) {
      final fastestVpn = tempList.first;
      Pref.vpn = fastestVpn;
      print('--- Fastest Server Found ---');
      print('Country: ${fastestVpn.countryLong}, Speed: ${fastestVpn.speed}, Ping: ${fastestVpn.ping}, Score: ${fastestVpn.score}');
    }
    // *****************************************************

    return tempList.isNotEmpty ? tempList.first : null;
  }


  /// Finds the closest VPN server based on the user's current location.
  Future<Vpn?> getClosestServer() async {
    // Show a loading indicator
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // 1. Get User's Location
      final userPosition = await _determinePosition();
      if (userPosition == null) {
        Get.back(); // Close loading dialog
        return null; // Failed to get user location
      }

      Vpn? closestVpn;
      double minDistance = double.infinity;

      // Ensure we have a server list to work with
      if (_originalVpnList.isEmpty) {
        await getVpnData();
      }

      // 2. Calculate distance to each server
      for (final vpn in _originalVpnList) {
        // Skip servers without valid coordinates
        if (vpn.lat == 0.0 || vpn.lon == 0.0) continue;

        final distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          vpn.lat,
          vpn.lon,
        );

        if (distance < minDistance) {
          minDistance = distance;
          closestVpn = vpn;
        }
      }

      Get.back(); // Close loading dialog
      return closestVpn;
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', 'Could not find closest server: ${e.toString()}');
      return null;
    }
  }

  /// Helper method to determine the current position of the device.
  /// Handles all the permission requests and logic.
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Services Disabled', 'Please enable location services to use this feature.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location Permissions Denied', 'Location permissions are denied, we cannot find the closest server.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location Permissions Denied Forever',
          'Location permissions are permanently denied, we cannot request permissions. Please enable them in your phone settings.');
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  }
}