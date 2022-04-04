import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youflutter/blocs/favoritos_bloc.dart';
import 'package:youflutter/screens/home.dart';
import 'package:youflutter/blocs/videos_bloc.dart';

void main() => runApp(YouFlutter());

class YouFlutter extends StatelessWidget {
  const YouFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => VideosBloc()), Bloc((i) => FavoritosBloc())],
      dependencies: [],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, title: 'YouFlutter', home: Home()),
    );
  }
}
