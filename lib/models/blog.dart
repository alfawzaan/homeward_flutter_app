class Blog {
  String id;
  String title;
  String image;
  String creationTime;

  Blog(this.id, this.title, this.image, this.creationTime);

  Blog.fromJson(
    Map<String, dynamic> json,
  )   : this.id = json["id"],
        this.title = json["title"],
        this.image = json["imageUrl"],
        this.creationTime = json["createdAt"];
}
