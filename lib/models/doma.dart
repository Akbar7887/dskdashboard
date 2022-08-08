import 'Kompleks.dart';

class Doma {
    int? id;
    Kompleks? kompleks;
    String? name;

    Doma({this.id, this.kompleks, this.name});

    factory Doma.fromJson(Map<String, dynamic> json) {
        return Doma(
            id: json['id'],
            kompleks: json['kompleks'] != null ? Kompleks.fromJson(json['kompleks']) : null,
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        if (this.kompleks != null) {
            data['kompleks'] = this.kompleks!.toJson();
        }
        return data;
    }
}