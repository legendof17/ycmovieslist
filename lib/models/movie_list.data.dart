class MovieList{
  int? id;
  String moviename = '';
  String directorname = '';
  String posterimage = '';

  movieListMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['moviename'] = moviename;
    mapping['directorname'] = directorname;
    mapping['posterimage'] = posterimage;

    return mapping;
  }
}