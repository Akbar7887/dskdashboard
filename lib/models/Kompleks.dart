class Kompleks {
  int? id;
  String? name;

  Kompleks({this.id, this.name});

  factory Kompleks.fromJson(Map<String, dynamic> json) {
    return Kompleks(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
