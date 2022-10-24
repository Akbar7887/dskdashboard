import 'ImageNews.dart';

class News {
    String? datacreate;
    String? description;
    int? id;
    List<ImageNews>? imageNewsList;
    String? imagepath;
    String? title;

    News({ this.datacreate, this.description, this.id, this.imageNewsList, this.imagepath, this.title});

    factory News.fromJson(Map<String, dynamic> json) {
        return News(
            datacreate: json['datacreate'],
            description: json['description'], 
            id: json['id'], 
            imageNewsList: json['imageNewsList'] != null ? (json['imageNewsList'] as List).map((i) => ImageNews.fromJson(i)).toList() : null, 
            imagepath: json['imagepath'], 
            title: json['title'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['datacreate'] = this.datacreate;
        data['description'] = this.description;
        data['id'] = this.id;
        data['imagepath'] = this.imagepath;
        data['title'] = this.title;
        if (this.imageNewsList != null) {
            data['imageNewsList'] = this.imageNewsList!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}