import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qr_reader/qr_reader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<String> _barcodeString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Home'),
      ),
      body: new SafeArea(
        child: new Container(
          child: Center(
            child: new Column(
              children: <Widget>[
                new FutureBuilder<String>(
                  future: _barcodeString,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return new Text(snapshot.data != null ? snapshot.data : '');
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
          });
        },
        child: new Icon(Icons.camera_alt),
      ),
    );
  }
}