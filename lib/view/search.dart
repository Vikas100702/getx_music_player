import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/text_style.dart';
import '../controllers/player_controller.dart';

class Search extends SearchDelegate {
  SongModel data = SongModel({});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    if(query!=null && data.(query.toLowerCase())){
      print("Data :$data");
      return ListTile(title: Text(query),);
    } else{
      print("Data :"+data.toString());
      print("SongModel :${SongModel(Map())}");
      return ListTile(title: Text("No result Found."),);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var controller = Get.put(PlayerController());
    // TODO: implement buildSuggestions
    return FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(
                /*child: CircularProgressIndicator(),*/
                child: Text('${snapshot.data.toString()}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Songs Found',
                style: ourStyle(size: 14),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data?[index].title.toString()}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                });
          }
        });
  }
}
