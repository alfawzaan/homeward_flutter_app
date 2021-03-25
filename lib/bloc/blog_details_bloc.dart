import 'package:homeward_flutter_app/models/blog_detail_response.dart';
import 'package:homeward_flutter_app/repository/request_repository.dart';
import 'package:rxdart/subjects.dart';

class BlogDetailsBloc{
  RequestRepository _repository = RequestRepository();
  BehaviorSubject<BlogDetailsResponse> _subject = BehaviorSubject<BlogDetailsResponse>();
  BehaviorSubject<BlogDetailsResponse> get subject => _subject;

   getBlogList(String token, String blogId)async{
    BlogDetailsResponse response = await _repository.doGetBlogDetails(token, blogId);
    _subject.sink.add(response);
  }

  dispose(){
     _subject.close();
  }

}

