# Paho MQTT JavaScript wrapper for Dart

## Setup

Download and place ```paho-mqtt-min.js``` into the ```./example``` directory, using
only the [v1.1.0 release](https://github.com/eclipse/paho.mqtt.javascript/releases/tag/v1.1.0).
It is recommended to download from the ```paho.javascript-1.1.0.zip``` asset.

## Run using Dart 2

First ensure you are running the latest version of Dart 2. Then activate webdev,
get all dependencies, and start the develoment web-server:

```sh
pub global activate webdev
pub get
webdev serve
```

Then start the MQTT server, such as Mosquitto, ensuring it is accessible via web-sockets.
The server details can be reconfigured in ```example/main.dart```. Publish messages
to the MQTT server and see the traffic in the browser console logs.