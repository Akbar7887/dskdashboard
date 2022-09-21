
import 'Dom.dart';

class PictureHome {
    String? datacreate;
    Dom? dom;
    int? id;
    String? imagepath;
    String? name;
    bool web;

    PictureHome({this.datacreate, this.dom, this.id, this.imagepath, this.name, required this.web});

    factory PictureHome.fromJson(Map<String, dynamic> json) {
        return PictureHome(
            datacreate: json['datacreate'], 
            dom: json['dom'] != null ? Dom.fromJson(json['dom']) : null, 
            id: json['id'], 
            imagepath: json['imagepath'], 
            name: json['name'],
            web: json['web']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['datacreate'] = this.datacreate;
        data['id'] = this.id;
        data['imagepath'] = this.imagepath;
        data['name'] = this.name;
        if (this.dom != null) {
            data['dom'] = this.dom!.toJson();
        }
        data['web'] = this.web;
        return data;
    }
}