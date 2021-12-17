import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

//apply this class on home: attribute at MaterialApp()
class WebSocketLed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}

class _WebSocketLed extends State<WebSocketLed> {
  late bool ledstatus; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  late bool connected; //boolean value to track if WebSocket is connected

  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "poweron:success") {
              ledstatus = true;
            } else if (message == "poweroff:success") {
              ledstatus = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: new Color.fromRGBO(119, 172, 241, 1),
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text("LED - ON/OFF NodeMCU"),
        backgroundColor: new Color.fromRGBO(119, 172, 241, 1),
      ),
      body: Container(
          alignment: Alignment.topCenter, //inner widget alignment to center
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: Text(
                  'Encender / Apagar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    color: Colors.blue[800]
                  ),
                ),
              ),
              Container(
                  child: ledstatus
                      ? Image(image: AssetImage("assets/FocoPrendido.png"))
                      : Image(image: AssetImage("assets/FocoApagado.png"))),
              Padding(
                padding: EdgeInsets.only(top: 35.0),
              ),
              Container(
                  child: connected
                      ? Text("WEBSOCKET: CONNECTED")
                      : Text("DISCONNECTED")),
              Container(
                  child: ledstatus ? Text("LED IS: ON") : Text("LED IS: OFF")),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Container(
                    // padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                        //button to start scanning
                        color: new Color.fromRGBO(119, 172, 241, 1),
                        colorBrightness: Brightness.dark,
                        onPressed: () {
                          //on button press
                          if (ledstatus) {
                            //if ledstatus is true, then turn off the led
                            //if led is on, turn off
                            sendcmd("poweroff");
                            ledstatus = false;
                          } else {
                            //if ledstatus is false, then turn on the led
                            //if led is off, turn on
                            sendcmd("poweron");
                            ledstatus = true;
                          }
                          setState(() {});
                        },
                        child: ledstatus
                            ? Text("TURN LED OFF")
                            : Text("TURN LED ON")),
                  ))
            ],
          )),
    );
  }
}
