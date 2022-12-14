import 'Dom.dart';

class ImageDom {
  String? datacreate;
  // Dom? dom;
  int? id;
  String? imagepath;
  String? name;
  bool? web;
  bool? layout;

  ImageDom(
      {this.datacreate,
      // this.dom,
      this.id,
      this.imagepath,
      this.name,
      this.web,
      this.layout});

  factory ImageDom.fromJson(Map<String, dynamic> json) {
    return ImageDom(
        datacreate: json['datacreate'],
        // dom: json['dom'] != null ? Dom.fromJson(json['dom']) : null,
        id: json['id'],
        imagepath: json['imagepath'],
        name: json['name'],
        web: json['web'],
        layout: json['layout']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datacreate'] = this.datacreate;
    data['id'] = this.id;
    data['imagepath'] = this.imagepath;
    data['name'] = this.name;
    // if (this.dom != null) {
    //   data['dom'] = this.dom!.toJson();
    // }
    data['web'] = this.web;
    data['layout'] = this.layout;

    return data;
  }
}
