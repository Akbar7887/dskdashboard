class Meneger {
  String? email;
  int? id;
  String? imagepath;
  String? name;
  String? phone;
  String? post;

  Meneger(
      {this.email, this.id, this.imagepath, this.name, this.phone, this.post});

  factory Meneger.fromJson(Map<String, dynamic> json) {
    return Meneger(
      email: json['email'],
      id: json['id'],
      imagepath: json['imagepath'],
      name: json['name'],
      phone: json['phone'],
      post: json['post'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['imagepath'] = this.imagepath;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['post'] = this.post;
    return data;
  }
}
