class Events {

  int? id;
  String? title;
  String? description;
  String? datecreate;


  Events({
      this.id, 
      this.title, 
      this.description, 
      this.datecreate,});

  Events.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    datecreate = json['datecreate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['datecreate'] = datecreate;
    return map;
  }

}