// screens/location_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/native_ad_controller.dart';
import '../helpers/ad_helper.dart';
import '../helpers/pref.dart';
import '../main.dart'; // For mq
import '../services/vpn_engine.dart';
import '../utils/constents/colors.dart';
import '../utils/helper/helper_functions.dart';
import '../widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  // Use Get.put for proper lifecycle management.
  // This ensures the controller is created and available.
  final _controller = Get.find<LocationController>();
  //  final fastestVpn = _controller.getAutoOptimalServer();
  final _adController = Get.put(NativeAdController());

  // Controller for the search text field
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch data only if the original list is empty (after app start)
    // The controller's onInit already handles the initial list from Prefs.
    if (_controller.vpnList.isEmpty && !_controller.isLoading.value) {
      _controller.getVpnData();
    }

    // Load ad if not already loaded
    if (_adController.ad == null && !_adController.adLoaded.value) {
      _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    }

    // Listen to text field changes to update the search query in the controller
    _searchController.addListener(() {
      _controller.setSearchQuery(_searchController.text);
    });
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(
          () => Scaffold(
        //app bar
        appBar: AppBar(
          title: Text('VPN Locations (${_controller.vpnList.length})'), // Shows filtered count
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: dark?TColors.white :TColors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),

        bottomNavigationBar:
        _adController.ad != null && _adController.adLoaded.isTrue
            ? SafeArea(
            child: SizedBox(
                height: 85, child: AdWidget(ad: _adController.ad!)))
            : null,

        //refresh button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              tooltip: 'Refresh Server List',
              onPressed: () {
                // Clear search and unfocus when refreshing
                _searchController.clear();
                _controller.setSearchQuery('');
                FocusScope.of(context).unfocus(); // Close keyboard
                _controller.getVpnData();
              },
              child: _controller.isLoading.value && _controller.vpnList.isEmpty
                  ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Icon(CupertinoIcons.refresh)
          ),
        ),

        // Body now has a Column to hold the search bar and the list
        body: Column(
          children: [
            // Search TextField
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Country...',
                  prefixIcon: Icon(CupertinoIcons.search, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(CupertinoIcons.clear_circled_solid, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                    onPressed: () {
                      _searchController.clear();
                      _controller.setSearchQuery('');
                    },
                  )
                      : null,
                ),
              ),
            ),

            SizedBox(height: 12),

            // Row for the two buttons
            Row(
              children: [
                // Closest Location Button
               /* Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // A different color
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(Icons.my_location_rounded, color: Colors.white, size: 20),
                    label: Text('Closest',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () async {
                      final closestVpn = await _controller.getClosestServer();
                      if (closestVpn != null) {
                       // _homeController.connectToSpecificVpn(closestVpn);
                      }
                    },
                  ),
                ),

                SizedBox(width: 10), */// Space between buttons

                // Fastest Server Button
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 20),
                    label: Text('Fastest',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      // Your existing logic for fastest server
                      final fastestVpn = _controller.getAutoOptimalServer();
                      if (fastestVpn != null) {
                       //
                        Get.back();
                        // Country: Japan, Speed: 924829824, Ping: 2, Score: 685034
                        final _homeController = Get.find<HomeController>();

                        if (_homeController.vpnState.value == VpnEngine.vpnConnected) {

                          VpnEngine.stopVpn();

                          Future.delayed(
                              Duration(seconds: 1), () {
                            _homeController.vpn.value =  Pref.vpn;

                                //_homeController.connectToVpn();

                              });

                        } else {
                          _homeController.connectToVpn();
                        }
                      } else {
                        Get.snackbar('Optimal Server',
                            'No suitable servers found for auto-connect.');
                      }
                    },
                  ),
                ),
              ],
            ),

            // The main content area
            Expanded(
              child: _controller.isLoading.value && _controller.vpnList.isEmpty
                  ? _loadingWidget()
                  : _controller.vpnList.isEmpty // Check the reactive/filtered list
                  ? _noVPNFound()
                  : _vpnData(),
            ),
          ],
        ),
      ),
    );
  }

  // This method now uses _controller.vpnList, which is already filtered/sorted
  Widget _vpnData() => ListView.builder(
    // The controller's RxList `vpnList` is automatically updated,
    // and Obx rebuilds this widget when it changes.
      itemCount: _controller.vpnList.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          mq.width * .04, 8, mq.width * .04, mq.height * .1), // Adjusted padding
      itemBuilder: (ctx, i) => VpnCard(vpn: _controller.vpnList[i]));

  Widget _loadingWidget() => Center( // Wrapped in Center for better positioning
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset('assets/lottie/loading.json',
            width: mq.width * .6), // Adjusted size
        SizedBox(height: 20),
        Text(
          'Loading VPNs... 😌',
          style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  );

  Widget _noVPNFound() => Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        // Show a different message if there are no results from a search
        _controller.searchQuery.value.isEmpty
            ? 'No VPN Servers Found! 😔\nTry refreshing the list.'
            : 'No VPNs found for "${_controller.searchQuery.value}" 😔',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}