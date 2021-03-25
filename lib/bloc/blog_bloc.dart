import 'package:homeward_flutter_app/models/blog_response.dart';
import 'package:homeward_flutter_app/repository/request_repository.dart';
import 'package:rxdart/rxdart.dart';

class BlogListBloc {
  //For making server request
  RequestRepository _repository = RequestRepository();
  BehaviorSubject<BlogResponse> _subject = BehaviorSubject<BlogResponse>();
  BehaviorSubject<BlogResponse> get subject => _subject;

  getBlogs(String token) async {
    BlogResponse response = await _repository.doGetBlogList(token);
    _subject.sink.add(response);
  }

  dispose(){
    _subject.close();
  }
}

