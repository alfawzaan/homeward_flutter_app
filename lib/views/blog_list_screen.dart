import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homeward_flutter_app/bloc/blog_bloc.dart';
import 'package:homeward_flutter_app/models/blog.dart';
import 'package:homeward_flutter_app/models/blog_detail_response.dart';
import 'package:homeward_flutter_app/models/blog_response.dart';
import 'package:homeward_flutter_app/views/blog_details_screen.dart';
import 'package:homeward_flutter_app/views/constants.dart';

class BlogListScreen extends StatefulWidget {
  String token;

  BlogListScreen(this.token);

  @override
  State createState() {
    return BlogListScreenState();
  }
}

class BlogListScreenState extends State<BlogListScreen> {
  BlogListBloc  blogListBloc = BlogListBloc();

  @override
  void initState() {
    super.initState();
    //PASS THE TOKEN TO BlogListBloc
    blogListBloc.getBlogs(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog List"),
        centerTitle: true,
      ),
      //STREAM BUILDER TO LISTEN TO BlogListBloc RESPONSE
      body: StreamBuilder(
        stream: blogListBloc.subject.stream,
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.hasData) {
            if (asyncsnapshot.data.error != null &&
                asyncsnapshot.data.error.length > 0) {
              return Center(child: Text("No Blog Entry at the moment"));
            }

            return blogListBuildComposer(asyncsnapshot.data);
          } else if (asyncsnapshot.hasError) {
            return Center(
                child: Text("An error occurred while fetching blog list"));
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

  //BUILD BLOG LIST FROM THE STREAM DATA
  blogListBuildComposer(BlogResponse blogResponse) {
    List<Blog> blogs = blogResponse.blogs;

    if (blogs.length == 0) {
      return Text("Sorry! no blog entry at the moment");
    } else {
      return ListView.builder(
        itemCount: blogs == null ? 0 : blogs.length,
        itemBuilder: (context, index) {
          var blog = blogs[index];
          return customDeco(blogBuildComposer(blog), Colors.white70,
              getWidth(context, ratio: .1));
        },
      );
    }
  }

  //PROCESS INDIVIDUAL BLOG DATA
  blogBuildComposer(Blog blog) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(context, ratio: 0.04),
            vertical: getWidth(context, ratio: 0.03)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                //Image.network(blog.image.replaceFirst("http", "https")),
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
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlogDetailsScreen(widget.token, blog.id);
        }));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    //CLOSE THE BlogListBloc
    blogListBloc.dispose();
  }
}
