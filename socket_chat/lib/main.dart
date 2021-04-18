import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket IO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Socket socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    try {
      socket = io("http://127.0.0.1:5000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.emit(
        "signin",
      );
      socket.onConnect((data) {
        print("Connected");
        socket.on("message", (msg) {
          print(msg);
        });
      });
      print(socket.connected);
    } catch (e) {
      print(e.toString());
    }
  }

  sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }

  handleLocationListen(Map<String, dynamic> data) async {
    print(data);
  }

  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  void handleTyping(Map<String, dynamic> data) {
    print(data);
  }

  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socket IO"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendMessage("Hiii ishita");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
