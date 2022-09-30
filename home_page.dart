import 'package:atividade04/UI/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = "";
  int _offset = 0;

  void _resetFields(){
    setState(() {
      _getGifs();
    });
  }

  int _getCount(List data){
    if(_search == ""){
      return data.length;
    }else{
      return data.length+1;
    }
  }

  Future<Map> _getGifs() async{
    http.Response response;
    if(_search == ""){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=YgRdbsKL12HFruJf1PRk3BgFWPj0eqjR&limit=25&rating=g"));
    } else{
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=YgRdbsKL12HFruJf1PRk3BgFWPj0eqjR&q=$_search&limit=25&offset=$_offset&rating=G&lang=en"));
    }
    return json.decode(response.body);

  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if(_search == "" || index < snapshot.data["data"].length){
          return GestureDetector(
            child: Container(
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(width: 5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.memoryNetwork(
                  key: UniqueKey(),
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
          );
        }else{
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Load more...", style: TextStyle(color: Colors.white, fontSize: 22.0),),
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 25;
                });
              },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: Image.asset("images/logo.png", width: 225.0, height: 200.0,),
        centerTitle: true,
        backgroundColor: Colors.white24,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetFields,),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage('images/wallpaper.png'),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50.0,
                  child: TextField(
                    cursorColor: Colors.deepPurpleAccent,
                    decoration:
                    const InputDecoration(
                      labelText: "Search here!",
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
                      hintText: "Type your search here!",
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 25),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      fillColor: Color.fromRGBO(141, 0, 199, 0.3),
                      filled: true,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    onSubmitted: (text){
                      setState(() {
                        _search = text;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if(snapshot.hasError){
                          return Container();
                        }else{
                          return _createGifTable(context, snapshot);
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}