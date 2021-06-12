import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:faller/creds.dart';
import 'package:faller/utils/fcm_push.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Init the app
  Future<void> initPlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _messaging.subscribeToTopic('faller');
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        message = "Notification received";
      });
    });

    // Create RTC client instance
    RtcEngineConfig config = RtcEngineConfig(Credentials.APP_ID);

    var engine = await RtcEngine.createWithConfig(config);
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
          child: Text(message),
        ),
      ),
    );
  }
}
