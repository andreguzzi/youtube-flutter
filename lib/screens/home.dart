import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youflutter/blocs/favoritos_bloc.dart';
import 'package:youflutter/blocs/videos_bloc.dart';
import 'package:youflutter/delegates/data_search.dart';
import 'package:youflutter/models/video.dart';
import 'package:youflutter/widgets/videotile.dart';
import 'package:youflutter/screens/favoritos.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    final FavoritosBloc favBloc = BlocProvider.getBloc<FavoritosBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 25,
            child: Image.asset("images/youtube_transparent_logo.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.black12,
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<Map<String, Video>>(
                initialData: {},
                stream: favBloc.outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("${snapshot.data!.length}");
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.stars),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => favoritos()));
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String? result =
                    await showSearch(context: context, delegate: DataSearch());
                if (result != null) videosBloc.inSearch.add(result);
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: StreamBuilder(
          stream: videosBloc.outVideos,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    videosBloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container(
                      child: Text(
                        "Busque pelo termo de seu video",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    );
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
