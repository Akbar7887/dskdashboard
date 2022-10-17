import 'Kompleks.dart';

class Dom {
    int? id;
    // Kompleks? kompleks;
    String? name;

    Dom({this.id,  this.name});

    factory Dom.fromJson(Map<String, dynamic> json) {
        return Dom(
            id: json['id'],
            // kompleks: json['kompleks'] != null ? Kompleks.fromJson(json['kompleks']) : null,
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        // if (this.kompleks != null) {
        //     data['kompleks'] = this.kompleks!.toJson();
        // }
        return data;
    }
}