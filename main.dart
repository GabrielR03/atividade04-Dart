import 'package:atividade04/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'GIF Searcher',
    home: HomePage(),
    theme: ThemeData(hintColor: Colors.white),
    debugShowCheckedModeBanner: false,
  ));
}
class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields(){
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Image.asset("images/logo.png"),
        centerTitle: true,
        backgroundColor: Colors.white70,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetFields,),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: const <Widget>[
          Image(
            image: AssetImage('images/wallpaper.png'),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}