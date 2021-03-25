class BlogDetails {
  String id;
  String title;
  String image;
  String creationTime;

  BlogDetails(this.id, this.title, this.image, this.creationTime);

  BlogDetails.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        image = json["imageUrl"],
        creationTime = json["createdAt"];
}
