import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_music_player/consts/colors.dart';
import 'package:getx_music_player/consts/text_style.dart';
import 'package:getx_music_player/controllers/player_controller.dart';
import 'package:getx_music_player/view/player.dart';
import 'package:getx_music_player/view/search.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    final searchController = TextEditingController();
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: ()=>showSearch(context: context, delegate: Search()),
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        title: Text(
          'TuneHub',
          style: ourStyle(
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Songs Found',
                style: ourStyle(size: 14),
              ),
            );
          } else {
            debugPrint("${snapshot.data}");
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(
                      () => Column(
                        children: [
                          ListTile(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                            tileColor: bgColor,
                            title: Text(
                              snapshot.data![index].displayNameWOExt,
                              style: ourStyle(size: 15),
                            ),
                            subtitle: Text(
                              snapshot.data![index].artist.toString(),
                              style: ourStyle(size: 12),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: whiteColor,
                                size: 32,
                              ),
                            ),
                            trailing: controller.playIndex == index &&
                                    controller.isPlaying.value
                                ? const Icon(
                                    Icons.pause,
                                    size: 26,
                                    color: whiteColor,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    size: 26,
                                    color: whiteColor,
                                  ),
                            onTap: () {
                              Get.to(
                                Player(
                                  data: snapshot.data!,
                                ),
                                transition: Transition.downToUp,
                              );
                              controller.playSong(
                                snapshot.data![index].uri,
                                index,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget search(TextEditingController searchController, var controller) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Get.back();
            //searchController=searchController.clear();
          },
        ),

        title: TextField(
          controller: searchController,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor: whiteColor,
          style: TextStyle(
              fontSize: 15, color: whiteColor, decoration: TextDecoration.none),
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: whiteColor,
            ),
            filled: true,
            fillColor: Colors.white30,
            hintText: "Search",
            hintStyle: TextStyle(color: whiteColor),
            isCollapsed: false,
            isDense: true,
            contentPadding: EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 5,
              right: 20,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(50),
            ),
            /*disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(12),
            ),*/
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
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
              child: Text('${snapshot.data.toString()}')
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Songs Found',
                style: ourStyle(size: 14),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? searchAudioId = snapshot.data?[index].id.toString();
                    if(searchController.text.isEmpty){
                      return Container(child:Center(child: Text("${snapshot.data?[index].id.toString()}"),));
                    } else if(searchAudioId!.toLowerCase().contains(searchController.text.toLowerCase())){
                      return ListTile(
                        tileColor: bgColor,
                        title: Text(
                          snapshot.data![index].displayNameWOExt,
                          style: ourStyle(size: 15),
                        ),
                        subtitle: Text(
                          snapshot.data![index].artist.toString(),
                          style: ourStyle(size: 12),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        trailing: controller.playIndex == index &&
                            controller.isPlaying.value
                            ? const Icon(
                          Icons.pause,
                          size: 26,
                          color: whiteColor,
                        )
                            : const Icon(
                          Icons.play_arrow,
                          size: 26,
                          color: whiteColor,
                        ),
                        onTap: () {
                          Get.to(
                            Player(
                              data: snapshot.data!,
                            ),
                            transition: Transition.downToUp,
                          );
                          controller.playSong(
                            snapshot.data![index].uri,
                            index,
                          );
                        },
                      );
                    } else {
                      return Container(/*child: Center(child: Text("Not Found"),),*/);
                    }
                  }),
            );
          }
        },
      ),
    );
  }
}
