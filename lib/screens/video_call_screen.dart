import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelId;

  const VideoCallScreen({super.key, required this.channelId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    // Create the RTC Engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: "<Your Agora App ID>", // Replace with your Agora App ID
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    // Set event listeners
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          if (mounted) {
            setState(() {});
          }
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("Remote user $uid joined");
          if (mounted) {
            setState(() {
              _remoteUid = uid;
            });
          }
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint("Remote user $uid left");
          if (mounted) {
            setState(() {
              _remoteUid = null;
            });
          }
        },
      ),
    );

    // Enable video
    await _engine.enableVideo();

    // Join the channel
    await _engine.joinChannel(
      token: 'null', // Replace with a valid token if required
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _toggleCamera() async {
    await _engine.muteLocalVideoStream(_isCameraOff);
    if (mounted) {
      setState(() {
        _isCameraOff = !_isCameraOff;
      });
    }
  }

  Future<void> _toggleMute() async {
    await _engine.muteLocalAudioStream(_isMuted);
    if (mounted) {
      setState(() {
        _isMuted = !_isMuted;
      });
    }
  }

  Future<void> _endCall() async {
    await _engine.leaveChannel();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: _endCall,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Remote video view
                _remoteUid != null
                    ? AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUid!),
                          connection:
                              RtcConnection(channelId: widget.channelId),
                        ),
                      )
                    : const Center(child: Text("Waiting for user...")),

                // Local video view
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: _toggleMute,
              ),
              IconButton(
                icon: Icon(
                  _isCameraOff ? Icons.videocam_off : Icons.videocam,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: _toggleCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
