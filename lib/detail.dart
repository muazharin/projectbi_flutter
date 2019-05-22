import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/templateForm/templateForm.dart';

import 'dart:async';
import 'dart:convert';

class Detail extends StatefulWidget {
  List list1;
  int index1;
  // DeskPage({String username, String id}): this.username = username, this.id = id;
  Detail({this.index1,this.list1});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<List> getData() async {
    final response = await http.get("$ip"+"/kegiatan/getPesertaKegiatan/${widget.list1[widget.index1]['id_kegiatan']}");
    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
        title: Text(widget.list1[widget.index1]['nama_kegiatan']),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: (){},
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['nama_lengkap'],
                  style: TextStyle(fontSize: 25.0, color: Colors.blueGrey),
                ),
                leading: new Icon(
                  Icons.perm_contact_calendar,
                  size: 36,
                  color: Colors.greenAccent,
                ),
                subtitle: new Text(
                  "${list[i]['email']}",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}