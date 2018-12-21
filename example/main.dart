import 'dart:js' as dartjs;
import 'dart:typed_data';

import 'package:pahojs/pahojs.dart' as pahojs;

onConnect(pahojs.OnConnectionResponse resp) {
  print('in onConnect');
  pahojs.Client c = resp.invocationContext['mqttClient'];
  c.subscribe('#');

  // publish some messages using the Message object
  var msg = pahojs.Message('my message as a string');
  msg.destinationName = 'from/self/send/string';
  c.send(msg);
  msg =
      pahojs.Message(Uint8List.fromList([0, 1, 2, 60, 61, 62, 253, 254, 255]));
  msg.destinationName = 'from/self/send/bytes';
  c.send(msg);

  // publish using the publish convenience function
  c.publish('from/self/publish/string', 'my string...', 0, false);
  c.publish('from/self/publish/bytes',
      Uint8List.fromList([0, 1, 2, 60, 61, 62, 253, 254, 255]), 0, false);
}

onConnectionLost(pahojs.OnConnectionResponse resp) {
  print('in onConnectionLost');
  print(resp.errorCode);
  print(resp.errorMessage);
}

onMessageArrived(pahojs.Message msg) {
  print('in onMessageArrived');
  print(msg);
  print(msg.destinationName);
  print('msg.PayloadStringError == ${pahojs.PayloadStringError(msg)}');
  if (!pahojs.PayloadStringError(msg)) {
    print(msg.payloadString);
  } else {
    print(msg.payloadBytes);
  }
}

main() {
  // main MQTT connection via websockets
  var c = pahojs.Client('localhost', 1884, 'dartBrowserClient');
  c.onConnectionLost = dartjs.allowInterop(onConnectionLost);
  c.onMessageArrived = dartjs.allowInterop(onMessageArrived);

  // connect and provide callback via closure
  // (in order to use the client object)
  c.connect(pahojs.ConnectOptions(
    timeout: 1,
    //keepAliveInterval: 60,
    //useSSL: false,
    //invocationContext: pahojs.UserData(
    //  mqttClient: c,
    //),
    invocationContext: dartjs.JsObject.jsify({
      'mqttClient': c,
    }),
    onSuccess: dartjs.allowInterop(onConnect),
    reconnect: true,
  ));
}
