import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeward_flutter_app/bloc/blog_bloc.dart';
import 'package:homeward_flutter_app/bloc/blog_details_bloc.dart';
import 'package:homeward_flutter_app/models/blog.dart';
import 'package:homeward_flutter_app/models/blog_detail_response.dart';
import 'package:homeward_flutter_app/models/blog_details.dart';
import 'package:homeward_flutter_app/models/blog_response.dart';
import 'package:homeward_flutter_app/views/constants.dart';

class BlogDetailsScreen extends StatefulWidget {
  String token;
  String id;

  BlogDetailsScreen(this.token, this.id);

  @override
  State createState() {
    return BlogDetailsScreenState();
  }
}

class BlogDetailsScreenState extends State<BlogDetailsScreen> {
  BlogDetailsBloc blogDetailsBloc = BlogDetailsBloc();

  @override
  void initState() {
    super.initState();
    //PASS THE TOKEN AND THE BLOG ID TO BlogListBloc
    blogDetailsBloc.getBlogList(widget.token, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Detail"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: blogDetailsBloc.subject.stream,
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.hasData) {
            if (asyncsnapshot.data.error != null &&
                asyncsnapshot.data.error.length > 0) {
              return Center(child: Text("Error fetching blog details"));
            }
            return blogDetailsBuildComposer(asyncsnapshot.data);
          } else if (asyncsnapshot.hasError) {
            return Center(
                child: Text("An error occurred while fetching blog details"));
          } else {
            return Center(
                child: SizedBox(
                    width: getWidth(context, ratio: .3),
                    child: LinearProgressIndicator()));
          }
        },
      ),
    );
  }

  //BUILD BLOG DETAILS AND HAND ERROR
  blogDetailsBuildComposer(BlogDetailsResponse blogResponse) {
    BlogDetails blog = blogResponse.blogDetail;

    if (blog == null) {
      return Center(child: Text("Sorry! Blog details unavailable"));
    } else {
      return customDeco(blogBuildComposer(blog), Colors.white70,
          getWidth(context, ratio: .02));
    }
  }

  //BUILD BLOG
  blogBuildComposer(BlogDetails blog) {
    debugPrint(
        "blogBuildComposer title: ${blog.title} image: ${blog.image} time: ${blog.creationTime} another: ${blog.id}");

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(context, ratio: 0.04),
          vertical: getWidth(context, ratio: 0.03)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: blog.image.replaceFirst("http", "https"),
                placeholder: (context, url) => Text("Loading..."),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Expanded(
                  child: Text(
                blog.title,
                softWrap: true,
                style: TextStyle(
                    fontSize: getWidth(context, ratio: .05),
                    fontWeight: FontWeight.bold),
              ))
            ],
          ),
          Align(
            child: Text(blog.creationTime),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //CLOSE THE BlogDetailsBloc
    blogDetailsBloc.dispose();
  }
}
