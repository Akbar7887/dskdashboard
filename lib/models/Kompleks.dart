import 'Dom.dart';

class Kompleks {
    String? customer;
    String? customerlink;
    String? dateproject;
    String? description;
    List<Dom>? domSet;
    int? id;
    String? mainimagepath;
    String? statusbuilding;
    String? title;
    String? typehouse;

    Kompleks({this.customer,
        this.customerlink,
        this.dateproject,
        this.description,
        this.domSet,
        this.id,
        this.mainimagepath,
        this.statusbuilding,
        this.title,
        this.typehouse});

    factory Kompleks.fromJson(Map<String, dynamic> json) {
        return Kompleks(
            customer: json['customer'], 
            customerlink: json['customerlink'], 
            dateproject: json['dateproject'], 
            description: json['description'], 
            domSet: json['domSet'] != null ? (json['domSet'] as List).map((i) => Dom.fromJson(i)).toList() : null,
            id: json['id'], 
            mainimagepath: json['mainimagepath'],
            statusbuilding: json['statusbuilding'], 
            title: json['title'], 
            typehouse: json['typehouse'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['customer'] = this.customer;
        data['customerlink'] = this.customerlink;
        data['dateproject'] = this.dateproject;
        data['description'] = this.description;
        data['id'] = this.id;
        data['statusbuilding'] = this.statusbuilding;
        data['title'] = this.title;
        data['typehouse'] = this.typehouse;
        if (this.domSet != null) {
            data['domSet'] = this.domSet!.map((v) => v.toJson()).toList();
        }
            data['mainimagepath'] = this.mainimagepath;
        return data;
    }
}