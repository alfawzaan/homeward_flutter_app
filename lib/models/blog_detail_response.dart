import 'package:flutter/cupertino.dart';
import 'package:homeward_flutter_app/models/blog_details.dart';

/// A class to parse the response of a blog detail
/// received from the server
class BlogDetailsResponse {
  BlogDetails blogDetail;
  String error;

  BlogDetailsResponse(this.blogDetail, this.error);

  BlogDetailsResponse.fromJson(Map<String, dynamic> json) {

    if (json.length > 0) {
      blogDetail = BlogDetails.fromJson(json);
    }
    error = "";
  }

  BlogDetailsResponse.withError(String errorValue)
      : blogDetail = null,
        error = errorValue;
}
