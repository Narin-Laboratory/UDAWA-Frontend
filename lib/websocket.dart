import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class WebSocketEvent {
  final WebSocketEventType type;
  final dynamic data;

  WebSocketEvent({required this.type, required this.data});
}

enum WebSocketEventType {
  message,
  error,
  closed,
}

class WebSocketService {
  IOWebSocketChannel? _channel;
  StreamController<WebSocketEvent>? _eventController;

  Stream<WebSocketEvent> get events => _eventController!.stream;

  String _generateSalt() {
    final Random random = Random.secure();
    var values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String _generateAuth(String salt, String apiKey) {
    final key = utf8.encode(apiKey);
    final bytes = utf8.encode(salt);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  void connect({required String serverUrl, required String apiKey}) {
    _eventController = StreamController<WebSocketEvent>();
    final url = "ws://" + serverUrl + "/ws";
    _channel = IOWebSocketChannel.connect(url);

    String salt = _generateSalt();
    String auth = _generateAuth(salt, apiKey);

    /*Future.delayed(Duration(seconds: 3), () {
      
    });*/
    final jsonData = {
      "salt": salt,
      "auth": auth,
    };

    final jsonString = jsonEncode(jsonData);
    sendMessage(jsonString);

    _channel!.stream.listen(
      (response) {
        print("Received from device: " + response);
        _eventController!.add(
            WebSocketEvent(type: WebSocketEventType.message, data: response));
      },
      onError: (error) {
        _eventController!
            .add(WebSocketEvent(type: WebSocketEventType.error, data: error));
      },
      onDone: () {
        _eventController!
            .add(WebSocketEvent(type: WebSocketEventType.closed, data: null));
      },
      cancelOnError: true,
    );
  }

  void sendMessage(String message) {
    if (_channel != null) {
      print("Send to device: " + message);
      _channel!.sink.add(message);
    }
  }

  void close() {
    _channel?.sink.close();
    _eventController?.close();
  }
}
