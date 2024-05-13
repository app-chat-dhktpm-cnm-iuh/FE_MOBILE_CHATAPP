import 'dart:async';

import 'package:fe_mobile_chat_app/constants.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompManager {
  static final StompManager _instance = StompManager._internal();

  factory StompManager() => _instance;
  late StreamController<StompFrame> _messageStreamController;

  StompClient? _stompClient;

  StompManager._internal();

 void connectToStomp()  {
    final config = StompConfig(
      url: socketUrl, // Replace with your STOMP server URL
      onConnect: onStompConnect,
      onWebSocketError: onWebSocketError,
    );

    _stompClient = StompClient(config: config);
     _stompClient?.activate();
  }

  void onStompConnect(StompFrame connectFrame) {
    // Handle successful STOMP connection here
    print("Websocket connect: ${_stompClient?.connected}");
  }

  void onWebSocketError(dynamic error) {
    // Handle connection errors here
    print("Websocket Error: ${error}");
  }

  void disconnectFromStomp() async {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  void sendStompMessage(String destination, String body) {

    // Send the STOMP message
    _stompClient?.send(destination: destination, body: body);
  }
  // Stream<StompFrame> subscribeToDestination(String destination) {
  //   _messageStreamController = StreamController<StompFrame>();
  //
  //   _stompClient?.subscribe(destination: destination, callback: (frame) {
  //     _messageStreamController.add(frame);
  //   });
  //
  //   return _messageStreamController.stream;
  // }
  void subscribeToDestination(String destination, void Function(StompFrame) callback) {
    _stompClient?.subscribe(
      destination: destination,
      callback: callback,
    );
  }
}