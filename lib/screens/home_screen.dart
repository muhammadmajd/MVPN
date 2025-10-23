// screens/home_screen.dart (Fixed Obx usage)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';
import '../helpers/pref.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import '../utils/helper/helper_functions.dart';
import '../widgets/count_down_timer.dart';
import 'drawer.dart';
import 'location_screen.dart';
import 'network_test_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.find<HomeController>();
  final _locationController = Get.find<LocationController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    final dark = THelperFunctions.isDarkMode(context);
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("MVPN"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Iconsax.menu_1),
          color: dark ? Colors.white : Colors.black,
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Random Connect Button in AppBar
          Obx(() => _controller.isRandomConnectionActive
              ? IconButton(
            onPressed: _controller.connectToRandomVpn,
            icon: Icon(
              Icons.stop_circle_outlined,
              color: Colors.red,
              size: 26,
            ),
            tooltip: 'Stop Random Connection',
          )
              : IconButton(
            onPressed: _controller.connectToRandomVpn,
            icon: Icon(
              Icons.shuffle,
              color: dark ? Colors.white : Colors.black,
              size: 26,
            ),
            tooltip: 'Connect Random Server',
          )),
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                  Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              Pref.isDarkMode = !Pref.isDarkMode;
            },
            icon: Icon(
              Pref.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
              size: 26,
            ),
          ),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () => Get.to(() => NetworkTestScreen()),
              icon: Icon(
                CupertinoIcons.info,
                size: 27,
              )),
        ],
      ),
     // bottomNavigationBar: _changeLocation(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(height: mq.height * .03),

              // Random Connection Status
              _randomConnectionStatus(),

              SizedBox(height: mq.height * .02),
              _vpnButton(),
              SizedBox(height: mq.height * .03),
              _statusAndTimer(),
              SizedBox(height: mq.height * .03),
              StreamBuilder<VpnStatus?>(
                initialData: VpnStatus(),
                stream: VpnEngine.vpnStatusSnapshot(),
                builder: (context, snapshot) {
                  return _dataGrid(snapshot.data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Random Connection Status Widget
  // In the _randomConnectionStatus method, update to show attempts:
  Widget _randomConnectionStatus() {
    return Obx(() {
      if (_controller.isRandomConnectionActive) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shuffle, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Trying  servers...',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                _controller.attemptInfo,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
  Widget _randomConnectionStatus111() {
    return Obx(() {
      if (_controller.isRandomConnectionActive) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shuffle, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Trying random servers...',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _vpnButton() => Obx(() => Column(
    children: [
      Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            _controller.connectToVpn();
          },
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _controller.getButtonColor.withOpacity(0.1),
              boxShadow: [
                if (_controller.vpnState.value != VpnEngine.vpnDisconnected)
                  BoxShadow(
                    color: _controller.getButtonColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
              ],
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _controller.getButtonColor.withOpacity(0.3),
              ),
              child: Container(
                width: mq.height * .14,
                height: mq.height * .14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.getButtonColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(height: 6),
                    Text(
                      _controller.getButtonText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // Additional Random Connect Button below main button
      SizedBox(height: 20),
      _controller.isRandomConnectionActive
          ? ElevatedButton.icon(
        onPressed: _controller.connectToRandomVpn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        icon: Icon(Icons.stop, size: 20),
        label: Text('Stop Searching'),
      )
          : ElevatedButton.icon(
        onPressed: _controller.connectToRandomVpn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        icon: Icon(Icons.shuffle, size: 20),
        label: Text('searching for a Server'),
      ),
    ],
  ));

  Widget _statusAndTimer() {
    return Obx(() {
      bool isConnected = _controller.vpnState.value == VpnEngine.vpnConnected;
      bool isRandomConnecting = _controller.isRandomConnectionActive;

      String statusText;
      if (isRandomConnecting) {
        statusText = 'Searching for best server...';
      } else if (isConnected) {
        statusText = tr('connected');
      } else {
        statusText = _controller.vpnState.value.replaceAll('_', ' ').toUpperCase();
      }

      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isRandomConnecting
                    ? Colors.orange
                    : Theme.of(Get.context!).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 10),
          if (isConnected)
            CountDownTimer(startTimer: true)
          else if (isRandomConnecting)
            Text(
              'Testing servers (10s timeout)...',
              style: TextStyle(fontSize: 13, color: Colors.orange.shade600),
            )
          else
            Text(
              tr('timer_will_start_after_connection'),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
        ],
      );
    });
  }

  Widget _dataGrid(VpnStatus? vpnStatus) {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      children: [
        // Country Card
        Obx(() => InkWell(
          onTap: () {
            Get.to(() => LocationScreen());
          },
          child: _infoCard(
            context: Get.context!,
            title: _controller.vpn.value.countryLong.isEmpty
                ? tr('country')
                : _controller.vpn.value.countryLong,
            subtitle: _controller.isRandomConnectionActive
                ? 'Searching...'
                : 'Tap to change',
            icon: _controller.vpn.value.countryLong.isNotEmpty
                ? CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                  'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
              onBackgroundImageError: (e, s) {},
            )
                : CircleAvatar(
              radius: 30,
              backgroundColor: _controller.isRandomConnectionActive
                  ? Colors.orange
                  : Colors.blueAccent,
              child: Icon(
                  _controller.isRandomConnectionActive
                      ? Icons.search
                      : Iconsax.global,
                  size: 30,
                  color: Colors.white
              ),
            ),
          ),
        )),

        // Ping Card
        Obx(() => _infoCard(
          context: Get.context!,
          title: _controller.isRandomConnectionActive
              ? 'Testing...'
              : '${_controller.vpn.value.ping.isNaN ? "N/A" : _controller.vpn.value.ping} ms',
          subtitle: _controller.isRandomConnectionActive
              ? 'Checking ping'
              : 'Ping',
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: _controller.isRandomConnectionActive
                ? Colors.orange
                : Colors.orangeAccent,
            child: Icon(
                _controller.isRandomConnectionActive
                    ? Icons.search
                    : Iconsax.wifi,
                size: 30,
                color: Colors.white
            ),
          ),
        )),

        // Download Card
        _infoCard(
          context: Get.context!,
          title: vpnStatus?.byteIn ?? '0 kbps',
          subtitle: 'Download',
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(Iconsax.arrow_down, size: 14, color: Colors.white),
          ),
        ),

        // Upload Card
        _infoCard(
          context: Get.context!,
          title: vpnStatus?.byteOut ?? '0 kbps',
          subtitle: 'Upload',
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.redAccent,
            child: Icon(Iconsax.arrow_up_3, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required BuildContext context,
    required String title,
    required Widget icon,
    String subtitle = '',
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 4),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _changeLocation(BuildContext context) => SafeArea(
    child: Obx(() => InkWell(
      onTap: () => Get.to(() => LocationScreen()),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: mq.width * .06),
        height: 65,
        child: Row(
          children: [
            Icon(Iconsax.global_search, color: Colors.white, size: 28),
            SizedBox(width: 15),
            Text(
              tr('changeLocation'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Spacer(),
            _controller.isRandomConnectionActive
                ? Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shuffle,
                  color: Colors.white, size: 16),
            )
                : CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.map,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28),
            ),
          ],
        ),
      ),
    )),
  );
}