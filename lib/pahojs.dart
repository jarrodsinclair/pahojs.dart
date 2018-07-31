@JS('Paho')
library pahojs;

import 'dart:typed_data';
import 'package:js/js.dart';

// dart: `client = new pahojs.Client(host, port, clientId)`
// ->js: `client = new Paho.Client(host, port, clientId)`
@JS()
class Client {
  external Client(String host, int port, String clientId);
  external String get host;
  external int get port;
  external String get clientId;
  external Function get onConnectionLost;
  external set onConnectionLost(Function f);
  external Function get onMessageArrived;
  external set onMessageArrived(Function f);
  external connect(ConnectOptions options);
  external subscribe(String filter);
  external send(Message message);
  external publish(
      String topic, dynamic payload); //TODO: {int qos, bool retained});
}

@JS()
@anonymous
class ConnectOptions {
  external Function get onSuccess;
  external int get timeout;
  external bool get reconnect;
  external bool get useSSL;
  external factory ConnectOptions({
    Function onSuccess,
    int timeout,
    bool reconnect,
    bool useSSL,
  });
}

// dart: `msg = new pahojs.Message(payload)`
// ->js: `msg = new Paho.Message(payload)`
@JS()
class Message {
  external Message(dynamic payload);
  external String get payloadString;
  external Uint8List get payloadBytes;
  external bool get duplicate;
  external String get destinationName;
  external set destinationName(String val);
  external int get qos;
  external set qos(int val);
  external bool get retained;
  external set retained(bool val);
}

bool PayloadStringError(Message msg) {
  try {
    String _ = msg.payloadString;
  } catch (_) {
    return true;
  }
  return false;
}

// TODO:
//
// wrap this up a bit more in order to provide:
//  - Dart streams (not just callbacks)
//  - optionally, wait until first connection to the MQTT server is made
//    (suppress first connection errors)
//  - more control over auto-reconnect, not just the pattern used in JavaScript
//
