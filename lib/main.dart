import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:js_interop_example/interop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JS Interop Demo',
      home: JsInteropDemo(),
    );
  }
}

class JsInteropDemo extends StatefulWidget {
  const JsInteropDemo({Key? key}) : super(key: key);

  @override
  _JsInteropDemoState createState() => _JsInteropDemoState();
}

class _JsInteropDemoState extends State<JsInteropDemo> {
  late ConnectionManager _connectionManager;

  @override
  void initState() {
    super.initState();

    final wrappedHandler = allowInterop(_onConnectionChanged);
    final connectionManagerOptions = ConnectionManagerOptions(
      connectionChangeHandler: wrappedHandler,
    );

    _connectionManager = ConnectionManager(connectionManagerOptions);
  }

  _onConnectionChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JS Interop Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Your current connection Effective Type is ',
                children: <TextSpan>[
                  TextSpan(
                      text: _connectionManager.currentEffectiveType,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Your current connection Downlink is ',
                children: <TextSpan>[
                  TextSpan(
                      text: _connectionManager.currentDownlink.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
