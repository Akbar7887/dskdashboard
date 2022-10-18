import 'Catalog.dart';

class Make {
  List<Catalog>? catalogs;
  String? description;
  int? id;
  String? name;
  String? imagepath;

  Make({this.catalogs, this.description, this.id, this.name, this.imagepath});

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      catalogs: json['catalogs'] != null
          ? (json['catalogs'] as List).map((i) => Catalog.fromJson(i)).toList()
          : null,
      description: json['description'],
      id: json['id'],
      name: json['name'],
      imagepath: json['imagepath'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
    data['imagepath'] = this.imagepath;
    if (this.catalogs != null) {
      data['catalogs'] = this.catalogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
