import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VideoCallService {
  static const String appId =
      "YOUR_AGORA_APP_ID"; // Replace with your Agora App ID
  static const String channelName =
      "test"; // Replace with your desired channel name
  static const String token =
      "YOUR_AGORA_TOKEN"; // Replace with your Agora Token

  late final RtcEngine _engine;
  final List<int> _remoteUidList = [];

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    // Set up Agora event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
              "Successfully joined the channel: ${connection.channelId}");
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("User joined the call: $uid");
          _remoteUidList.add(uid);
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint("User offline: $uid");
          _remoteUidList.remove(uid);
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint("Left the channel");
        },
      ),
    );
  }

  Future<void> joinCall() async {
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveCall() async {
    await _engine.leaveChannel();
  }

  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

  Future<void> toggleLocalVideo(bool isMuted) async {
    await _engine.muteLocalVideoStream(isMuted);
  }

  Future<void> toggleLocalAudio(bool isMuted) async {
    await _engine.muteLocalAudioStream(isMuted);
  }

  Widget renderLocalVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget renderRemoteVideo(int uid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
        connection: const RtcConnection(channelId: channelName),
      ),
    );
  }

  Future<void> dispose() async {
    await _engine.release();
  }
}
