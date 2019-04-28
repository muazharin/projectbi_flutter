import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_bi/homePage.dart';

void main() => runApp(MyApp());

String username;

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
        '/home': (BuildContext context) => new HomePage()
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  final controllerUser = new TextEditingController();
  final controllerPass = new TextEditingController();

  String pesan = '';

  Future<List> login() async{
    if(validateAndSave()){
      try {
        final response = await http.post("http://192.168.2.79/bi/login.php",
        body:{
          "username" : controllerUser.text,
          "password" : controllerPass.text
        });
        var datauser = json.decode(response.body);
        Navigator.pushReplacementNamed(context, '/home');
        setState(() {
          username=datauser[0]['username'];
          pesan="Selamat anda berhasil login";
        });
        return datauser;
      } catch (e) {
        print(e.message);
      }
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
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) => value.isEmpty ? 'Username can\'t be empty':null,
                  controller: controllerUser,
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
                  validator: (value) => value.isEmpty ? 'Password can\'t be empty':null,
                  controller: controllerPass,
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
                        controllerUser.clear();
                        controllerPass.clear();
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
    );
  }
}