import 'package:flutter/cupertino.dart';

import 'blog.dart';

///a class to parse the response of blog list that was received from the server
class BlogResponse {
  List<Blog> blogs;
  String error;

  BlogResponse(this.blogs, this.error);

  BlogResponse.fromJson(List<dynamic> response)
      : blogs = response.map((e) {
          return Blog.fromJson(e);
        }).toList(),
        error = "";

  BlogResponse.withError(String errorValue)
      : blogs = List(),
        error = errorValue;
}
