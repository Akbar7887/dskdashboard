class Event {
  Event({
      this.id, 
      this.title, 
      this.description, 
      this.datecreate,});

  Event.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    datecreate = json['datecreate'];
  }
  int id;
  String title;
  String description;
  String datecreate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['datecreate'] = datecreate;
    return map;
  }

}