import 'package:ycmovie/models/movie_list.data.dart';
import 'package:ycmovie/repositories/repository.dart';

class MoviesListService{
  late Repository _repository;

  MoviesListService() {
    _repository = Repository();
  }

  saveMovie(MovieList list) async {
    return await _repository.insertData('movieslist', list.movieListMap());
  }

  readMoviesList() async {
    return await _repository.readData('movieslist');
  }

  readMovieById(movieId) async {
    return await _repository.readDataById('movieslist', movieId);
  }

  updateMovie(MovieList list) async {
    return await _repository.updateData('movieslist', list.movieListMap());
  }

  deleteMovie(movieId) async {
    return await _repository.deleteData('movieslist', movieId);
  }

  delMovies() async {
    return await _repository.delDatas('movieslist');
  }

  mockfake() async {
    return await _repository.fakemock('movieslist');
  }


}