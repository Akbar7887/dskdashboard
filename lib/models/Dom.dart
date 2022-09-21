import 'Kompleks.dart';

class Dom {
    String? active;
    int? id;
    Kompleks? kompleks;
    String? name;

    Dom({this.active, this.id, this.kompleks, this.name});

    factory Dom.fromJson(Map<String, dynamic> json) {
        return Dom(
            active: json['active'], 
            id: json['id'], 
            kompleks: json['kompleks'] != null ? Kompleks.fromJson(json['kompleks']) : null, 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['active'] = this.active;
        data['id'] = this.id;
        data['name'] = this.name;
        if (this.kompleks != null) {
            data['kompleks'] = this.kompleks!.toJson();
        }
        return data;
    }
}