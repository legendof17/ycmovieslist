import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ycmovie/models/movie_list.data.dart';
import 'package:ycmovie/screens/home_screen.dart';
import 'package:ycmovie/services/movies_list_service.data.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MoviesList extends StatefulWidget {
  const MoviesList({Key? key}) : super(key: key);

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  var _movieNameController = TextEditingController();
  var _directorNameController = TextEditingController();
  var _posterImage;

  var _list = MovieList();
  var _moviesService = MoviesListService();

  List<MovieList> _movieList = [];

  var movie;
  late File _image = File('');
  final ety = '';

  var _editmovieNameController = TextEditingController();
  var _editdirectorNameController = TextEditingController();
  var _editposterImage;

  void initState() {
    super.initState();
    getAllMovies();
  }

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  getAllMovies() async {
    _movieList = [];
    var moviesList = await _moviesService.readMoviesList();
    moviesList.forEach((movie) {
      setState(() {
        var movieListModel = MovieList();
        movieListModel.id = movie['id'];
        movieListModel.moviename = movie['moviename'];
        movieListModel.directorname = movie['directorname'];
        movieListModel.posterimage = movie['posterimage'];

        _movieList.add(movieListModel);
      });
    });
  }

  _editMovieData(BuildContext context, movieId) async {
    movie = await _moviesService.readMovieById(movieId);
    setState(() {
      _editmovieNameController.text = movie[0]['moviename'] ?? 'No Movie Name';
      _editdirectorNameController.text =
          movie[0]['directorname'] ?? 'No Movie Name';
      _editposterImage = movie[0]['posterimage'] ?? 'No Movie Poster';
    });
    _editFormDialog(context);
  }

  _clearStateData() async {
    setState(() {
      _movieNameController.text = '';
      _directorNameController.text = '';
      _posterImage = '';
      _image = File('');
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 640);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _posterImage = base64Encode(_image.readAsBytesSync());
      });
    }
    Navigator.of(context).pop();
    _addDataFormDialog(context);
  }

  _imgFromCamera() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 640);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _posterImage = base64Encode(_image.readAsBytesSync());
      });
    }
    Navigator.of(context).pop();
    _addDataFormDialog(context);
  }

  _editimgFromGallery() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 640);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _editposterImage = base64Encode(_image.readAsBytesSync());
      });
    }
    Navigator.of(context).pop();
    _editFormDialog(context);
  }

  _editimgFromCamera() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 640);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _editposterImage = base64Encode(_image.readAsBytesSync());
      });
    }
    Navigator.of(context).pop();
    _editFormDialog(context);
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editshowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _editimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _editimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _addDataFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () async {
                    var _list = new MovieList();
                    _list.moviename = _movieNameController.text;
                    _list.directorname = _directorNameController.text;
                    _list.posterimage = _posterImage;

                    var result = await _moviesService.saveMovie(_list);

                    if (result > 0) {
                      Navigator.pop(context);
                      getAllMovies();
                      print(_list);
                      _clearStateData();
                    }
                  },
                  child: Text('Save'))
            ],
            title: Text('Add Movie Data'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      _posterImage = await _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: _image.path != ety
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                  TextField(
                    controller: _movieNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a Movie Name',
                        labelText: 'Movie Name'),
                  ),
                  TextField(
                    controller: _directorNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a Director Name',
                        labelText: 'Director Name'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    var image = Image.memory(base64Decode(_editposterImage));
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  onPressed: () async {
                    _list.id = movie[0]['id'];
                    _list.moviename = _editmovieNameController.text;
                    _list.directorname = _editdirectorNameController.text;
                    _list.posterimage = _editposterImage;

                    var result = await _moviesService.updateMovie(_list);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllMovies();
                      _showSuccessSnackBar(Text('Updated'));
                    }
                  },
                  child: Text('Update'))
            ],
            title: Text('Edit Movie Data'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await _editshowPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: _editposterImage != (ety)
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: image.image)),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                  TextField(
                    controller: _editmovieNameController,
                    decoration: InputDecoration(
                        hintText: 'Edit Movie Name', labelText: 'Movie Name'),
                  ),
                  TextField(
                    controller: _editdirectorNameController,
                    decoration: InputDecoration(
                        hintText: 'Edit Director Name',
                        labelText: 'Director Name'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, movieId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.red),
                  onPressed: () async {
                    var result = await _moviesService.deleteMovie(movieId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllMovies();
                      _showSuccessSnackBar(Text('Deleted'));
                    }
                  },
                  child: Text('Delete'))
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = new SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Movies List'),
      ),
      body: ListView.builder(
          itemCount: _movieList.length,
          itemBuilder: (context, index) {
            var image = Image.memory(
                base64Decode(_movieList[index].posterimage),
                width: 50,
                height: 50);
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  child: Column(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: image.image)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 25, left: 20),
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Movie: ${_movieList[index].moviename}',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 190,
                                child: Text(
                                    'Director: ${_movieList[index].directorname}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        ),
                        Column(children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editMovieData(context, _movieList[index].id);
                            },
                          ),
                          SizedBox(height: 10,),
                          IconButton(
                              onPressed: () {
                                _deleteFormDialog(
                                    context, _movieList[index].id);
                              },
                              icon: Icon(Icons.delete, color: Colors.red))
                        ])
                      ],
                    ),
                  ),
                ],
              )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addDataFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
