import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';

class GifPage extends StatelessWidget{
  final Map _gifData;
  GifPage(this._gifData);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.white24,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: (){
            FlutterShare.share(
                title: _gifData["title"],
                linkUrl: _gifData["url"],
                text: "GIF sended by Gabriel Rodrigues GIF Searcher"
            );
          }),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
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
              image: _gifData["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

}