import 'ImageData.dart';
import 'Kompleks.dart';

class Dom {
  int? id;

  // Kompleks? kompleks;
  String? name;
  List<ImageDom>? imagedom;

  Dom({this.id, this.imagedom, this.name});

  factory Dom.fromJson(Map<String, dynamic> json) {
    return Dom(
      id: json['id'],
      // kompleks: json['kompleks'] != null ? Kompleks.fromJson(json['kompleks']) : null,
      name: json['name'],
      imagedom: json['imageDataList'] != null
          ? (json['imageDataList'] as List)
              .map((i) => ImageDom.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.imagedom != null) {
      data['imageDataList'] = this.imagedom!.map((v) => v.toJson()).toList();
    }
    // if (this.kompleks != null) {
    //     data['kompleks'] = this.kompleks!.toJson();
    // }
    return data;
  }
}
