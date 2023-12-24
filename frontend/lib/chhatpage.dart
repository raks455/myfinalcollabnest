//import 'package:agora_rtc_engine/agora_rtc_engine.dart';
//import 'package:agora_rtc_engine/rtc_engine.dart';
//flimport 'package:flutter/material.dart';

/*import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class ChatPage extends StatefulWidget {
  final token;

  const ChatPage({Key? key, @required this.token}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late RtcEngine _engine;
  bool _joined = false;
  bool _inCall = false;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(widget.token));

    await _engine.enableVideo();

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          print('joinChannelSuccess: $channel, uid: $uid');
          setState(() {
            _joined = true;
          });
        },
        userJoined: (uid, elapsed) {
          print('userJoined: $uid');
          setState(() {
            _inCall = true;
          });
        },
        userOffline: (uid, reason) {
          print('userOffline: $uid, reason: $reason');
          setState(() {
            _inCall = false;
          });
        },
      ),
    );

    await _engine.joinChannel(widget.token, 'demo', null, 0);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Center(
        child: _inCall
            ? _renderRemoteVideo()
            : (_joined ? Text('Waiting for user to join...') : Text('Joining...')),
      ),
    );
  }

  Widget _renderRemoteVideo() {
    return RtcRemoteView.SurfaceView(uid: 0);
  }
}
*/