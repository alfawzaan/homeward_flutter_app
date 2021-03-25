import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:homeward_flutter_app/models/blog_detail_response.dart';
import 'package:homeward_flutter_app/models/blog_response.dart';
import 'package:homeward_flutter_app/models/login_token_response.dart';

class RequestRepository {
  final Dio _dio = Dio();

  Future<LoginTokenResponse> doLoginUser(String email, String password) async {
    String loginUrl =
        "https://60585b2ec3f49200173adcec.mockapi.io/api/v1/login";
    var params = {"username": email, "password": password};
    try {
      Response response = await _dio.post(loginUrl, queryParameters: params);
      return LoginTokenResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      debugPrint("Exception occured: $error stackTrace: $stackTrace");
      return LoginTokenResponse.withError("${error}");
    }
  }

  Future<BlogResponse> doGetBlogList(String token) async {
    String loginUrl =
        "https://60585b2ec3f49200173adcec.mockapi.io/api/v1/blogs";

    try {
      _dio.options.headers["authorization"] = "Bearer ${token}";
      Response response = await _dio.get(loginUrl);
      return BlogResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      debugPrint("Exception occured: $error stackTrace: $stackTrace");
      return BlogResponse.withError("$error");
    }
  }

  Future<BlogDetailsResponse> doGetBlogDetails(
      String token, String blogId) async {
    String loginUrl =
        "https://60585b2ec3f49200173adcec.mockapi.io/api/v1/blogs/$blogId";
    var param = {"blogId": blogId};
    debugPrint("doGetBlogDetails $blogId");

    try {
      _dio.options.headers["authorization"] = "Bearer ${token}";
      Response response = await _dio.get(loginUrl);
      debugPrint("doGetBlogDetails RESPONSE: ${response.data}");
      return BlogDetailsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      debugPrint("Exception occured: $error stackTrace: $stackTrace");
      return BlogDetailsResponse.withError("$error");
    }
  }
}
