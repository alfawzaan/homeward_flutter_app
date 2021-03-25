import 'package:homeward_flutter_app/models/login_token_response.dart';
import 'package:homeward_flutter_app/repository/request_repository.dart';
import 'package:rxdart/subjects.dart';

class UserLoginBloc {
  RequestRepository _repository = RequestRepository();
  BehaviorSubject<LoginTokenResponse> _subject =
      BehaviorSubject<LoginTokenResponse>();

  BehaviorSubject<LoginTokenResponse> get subject => _subject;

  getToken(String email, String password) async {
    LoginTokenResponse token = await _repository.doLoginUser(email, password);
    _subject.sink.add(token);
  }

  dispose() {
    _subject.close();
  }
}


