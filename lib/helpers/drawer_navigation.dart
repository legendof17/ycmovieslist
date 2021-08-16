import 'package:flutter/material.dart';
import 'package:ycmovie/screens/home_screen.dart';
import 'package:ycmovie/screens/movies_list.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://greekturtle-prod.s3.amazonaws.com/71d6ed1c-9629-4597-8810-676c33f69c19'),
                ),
                accountName: Text('Jaffer Ali'),
                accountEmail: Text('jz6977@srmist.edu.in'),
                decoration: BoxDecoration(color: Colors.blue)),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()))),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Movies List'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MoviesList()))
            )
          ],
        ),
      ),
    );
  }
}
