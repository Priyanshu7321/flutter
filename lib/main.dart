import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewExample(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Check for initial connection and listen for changes
    _checkConnectivity();
    _listenToConnectionChanges();
  }

  void _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _loadWebPage();
    } else {
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _listenToConnectionChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none && !_isConnected) {
        _loadWebPage();
      } else if (result == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  void _loadWebPage() {
    setState(() {
      _isConnected = true;
    });
    _controller.loadRequest(Uri.parse('https://freshlifebites.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isConnected
            ? WebViewWidget(controller: _controller)
            : const Center(
                child: Text("No internet connection"),
              ),
      ),
    );
  }
}
