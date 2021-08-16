import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycmovie/helpers/drawer_navigation.dart';
import 'package:ycmovie/services/movies_list_service.data.dart';

import 'movies_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _moviesService = MoviesListService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _moviesService.delMovies();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MoviesList()));
              },
              onLongPress: () {
                _moviesService.mockfake();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MoviesList()));
              },
              child: Icon(Icons.android),
            )
          ],
        ),
        drawer: DrawerNavigation(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Icon(Icons.android),
            ),
            Container(
              child: Text('Tap to Delete all the datas', style: TextStyle(fontSize: 25)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text('Long press to Delete all the datas', style: TextStyle(fontSize: 25)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text('Else start by accessing drawer menu', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            ),
          ],
        )));
  }
}
