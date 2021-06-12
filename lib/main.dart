import 'dart:async';
import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:faller/creds.dart';
import 'package:faller/utils/fcm_push.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(home: FallerApp()));
}

class FallerApp extends StatefulWidget {
  const FallerApp({Key key}) : super(key: key);

  @override
  _FallerAppState createState() => _FallerAppState();
}

class _FallerAppState extends State<FallerApp> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  var _messaging;
  String message = 'Please chat';
  bool speakerPhone = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  RtcEngineConfig config = RtcEngineConfig(Credentials.APP_ID);
  var engine;

  // Init the app
  Future<void> initPlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _messaging.subscribeToTopic('faller');
    FirebaseMessaging.onMessage.listen((event) async {
      setState(() {
        message = "Notification received";
      });
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    engine = await RtcEngine.createWithConfig(config);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }));
    // Join channel with channel name as 123
    await engine.joinChannel(Credentials.TOKEN, 'faller_channel1', null, 0);
    engine.setEnableSpeakerphone(true);
  }

  toggleSpeaker() {
    setState(() {
      speakerPhone = !speakerPhone;
    });
    engine.setEnableSpeakerphone(speakerPhone);
  }

  // Build chat UI
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agora Audio quickstart',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.message_outlined,
          ),
          onPressed: () async {
            bool sent = await FcmPush.postRequest();
            setState(() {
              message += sent.toString();
            });
          },
        ),
        appBar: AppBar(
          title: Text('Agora Audio quickstart'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              TextButton(
                  onPressed: () => toggleSpeaker(),
                  child: Text('Speaker is on- $speakerPhone')),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage event) async {
  print("Received");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const int insistentFlag = 4;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          autoCancel: false,
          playSound: true,
          fullScreenIntent: true,
          additionalFlags: Int32List.fromList(<int>[insistentFlag]));
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'insistent title',
    'insistent body',
    platformChannelSpecifics,
    payload: 'item x',
  );
}
