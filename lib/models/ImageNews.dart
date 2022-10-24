class ImageNews {
  int? id;
  String? imagepath;

  ImageNews({this.id, this.imagepath});

  factory ImageNews.fromJson(Map<String, dynamic> json) {
    return ImageNews(
      id: json['id'],
      imagepath: json['imagepath'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagepath'] = this.imagepath;
    return data;
  }
}
