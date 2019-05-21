import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/homePage.dart';
import 'package:project_bi/deskPage.dart';
import 'package:project_bi/register.dart';
import 'package:project_bi/templateForm/templateForm.dart';

void main() => runApp(MyApp());

String username;
String id;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/deskPage': (BuildContext context) => new DeskPage(username: username, id: id),
        '/register': (BuildContext context) => new RegistPage(),
        '/login': (BuildContext context) => new LoginPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  GlobalKey<FormState> formKey = new GlobalKey();
  bool _validate = false;
  String _username, _password;

  String pesan = '';

  Future<List> login() async{
  
    if(formKey.currentState.validate()){
        formKey.currentState.save();
        print(_username);
        final response = await http.post("$ip"+"/login",
        headers:{ "Accept": "application/json" },
        body:{
          "username" : _username,
          "password" : _password
        });
        var datauser = json.decode(response.body);
        if(datauser.length == 0){
          setState(() {
            pesan="Username atau password salah!";
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Login"),
                content: new Text("$pesan"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }else{
          Navigator.pushReplacementNamed(context, '/deskPage');
          setState(() {
            username=datauser[0]['username'];
            id=datauser[0]['id'];
            pesan="Selamat anda berhasil login";
          });
        }
        return datauser;
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            autovalidate: _validate,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: validationUser,
                    onSaved: (String val){
                      _username = val;
                    },
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Username'
                    )
                  ),
                  TextFormField(
                    validator: validationPass,
                    onSaved: (String val){
                      _password = val;
                    },
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.blue,
                      ),
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('Sign Up'),
                      ),
                      RaisedButton(
                        onPressed: login,
                        child: Text('Login'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}