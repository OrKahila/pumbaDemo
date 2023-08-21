import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:demoapp/animations/fade_transition.dart';
import 'package:demoapp/models/user.dart';
import 'package:demoapp/splash.dart';
import 'package:demoapp/widgets/app_button.dart';
import 'package:demoapp/widgets/loading_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../widgets/app_icon.dart';
import '../widgets/background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool serviceEnabled;

    toggleLoading();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        toggleLoading();
        return null;
      }
    }

    _locationData = await location.getLocation();

    toggleLoading();

    return _locationData;
  }

  Future<void> hasPermissionCheck() async {
    Location location = Location();
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();

    if (permissionGranted != PermissionStatus.granted) {
      hasPermission = false;
    } else {
      hasPermission = true;
      getLocation();
    }

    setState(() {});
  }

  Future<void> requestPermission() async {
    Location location = Location();
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        hasPermission = false;
      } else {
        hasPermission = true;
        getLocation();
      }
    } else {
      hasPermission = true;
      getLocation();
    }

    print(permissionGranted.name);

    setState(() {});
  }

  LocationData? _locationData;
  bool hasPermission = false;
  bool hasNotificationPermissions = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final duration = Duration(minutes: 2);
  Timer? _timer;
  int remainingTimeInSeconds = 2 * 60;

  Future<void> checktNotificationPermissions() async {
    const settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: settingsAndroid,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var permissionStatus = await ph.Permission.notification.status;

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      setState(() {
        hasNotificationPermissions = true;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTimeInSeconds <= 0) {
          sendNotification();
          timer.cancel();
        } else {
          remainingTimeInSeconds--;
        }
      });
    });
  }

  Future<void> sendNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'timer_channel_id', 'Timer Channel',
        channelDescription: '',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
        0, 'Timer Finished', 'The timer has ended.', platformChannelSpecifics);
  }

  Future<void> requestNotificationPermissions() async {
    var permissionStatus = await ph.Permission.notification.request();

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      setState(() {
        hasNotificationPermissions = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    hasPermissionCheck();
    checktNotificationPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserStats>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () async {
              HapticFeedback.lightImpact();
              if (_timer != null) {
                _timer!.cancel();
              }

              final userId = FirebaseAuth.instance.currentUser!.uid;

              await FirebaseAuth.instance.currentUser!.delete();
              await userProvider.removeUserStata(userId);

              Navigator.of(context).push(FadeTransiton(const Splash(), 300));
            },
            icon: const Icon(Icons.delete),
            iconSize: 20,
          ),
        ],
        backgroundColor: Colors.transparent,
        title: const AppIcon(size: 30),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          const MyBackground(),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 400),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${userProvider.firstname} ${userProvider.lastname}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const DelayedDisplay(
                    delay: Duration(milliseconds: 1000),
                    child: Text(
                      'how are you today?',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (_isLoading) const SizedBox(height: 20),
                  if (_isLoading) const LoadingSpinner(),
                  if (_locationData != null && hasPermission)
                    const SizedBox(height: 20),
                  if (_locationData != null && hasPermission)
                    Text(
                      'Latitude: ${_locationData?.latitude}, Longitude: ${_locationData?.longitude}',
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (_timer != null && _timer!.isActive)
                    const SizedBox(height: 20),
                  if (_timer != null && _timer!.isActive)
                    Text(
                      'The notification will appear in:${remainingTimeInSeconds ~/ 60}:${(remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  const Expanded(child: SizedBox()),
                  if (!hasPermission)
                    const DelayedDisplay(
                      delay: Duration(milliseconds: 2000),
                      child: MyImageIcon(icon: 'location', size: 150),
                    ),
                  const SizedBox(height: 30),
                  if (!hasPermission)
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 2000),
                      child: AppButton(
                        onPressed: requestPermission,
                        text: 'Allow location',
                        color: const Color.fromARGB(255, 4, 152, 127),
                      ),
                    ),
                  if (_timer == null) const SizedBox(height: 15),
                  if (_timer == null)
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 2000),
                      child: AppButton(
                        onPressed: () {
                          if (hasNotificationPermissions) {
                            startTimer();
                          } else {
                            requestNotificationPermissions();
                          }
                        },
                        text: 'Start',
                        color: const Color.fromARGB(255, 4, 152, 127),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
