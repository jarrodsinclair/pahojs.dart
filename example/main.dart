import 'dart:typed_data';
import 'package:pahojs/pahojs.dart' as pahojs;

onConnect(pahojs.Client c) {
  print('in onConnect');
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
  c.publish('from/self/publish/string', 'my string...');
  c.publish('from/self/publish/bytes',
      Uint8List.fromList([0, 1, 2, 60, 61, 62, 253, 254, 255]));
}

onConnectionLost() {
  print('in onConnectionLost');
}

onMessageArrived(pahojs.Message msg) {
  print('in onMessageArrived');
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
  c.onConnectionLost = onConnectionLost;
  c.onMessageArrived = onMessageArrived;

  // connect and provide callback via closure
  // (in order to use the client object)
  c.connect(pahojs.ConnectOptions(
    onSuccess: () {
      onConnect(c);
    },
    reconnect: true,
    timeout: 1,
  ));
}
