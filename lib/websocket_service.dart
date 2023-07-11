import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

class WebsocketService {
  IOWebSocketChannel? _channel;
  int? _closeCode;

  void initialize(String serverAddress, String apiKey) {
    var salt = utf8.encode(_generateSalt());
    var key = utf8.encode(apiKey);
    var hamacSha256 = Hmac(sha256, key);
    var result = hamacSha256.convert(salt);
    var auth = utf8.decode(result.bytes);

    _channel = IOWebSocketChannel.connect('ws://$serverAddress/ws');
    _channel!.sink.add(jsonEncode({'salt': salt, 'auth': auth}));
  }

  Stream<dynamic> get messages => _channel!.stream;

  void close() {
    _channel?.sink.close(1000);
  }

  bool isConnected() {
    return _channel != null && _closeCode == null;
  }

  String _generateSalt() {
    var rnd = Random();
    List<int> list = List<int>.generate(16, (index) => rnd.nextInt(256));
    return base64.encode(list);
  }
}
