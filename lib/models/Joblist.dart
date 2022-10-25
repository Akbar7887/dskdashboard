class Joblist {
    String? description;
    int? id;
    bool? title;

    Joblist({this.description, this.id, this.title});

    factory Joblist.fromJson(Map<String, dynamic> json) {
        return Joblist(
            description: json['description'], 
            id: json['id'], 
            title: json['title'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['description'] = this.description;
        data['id'] = this.id;
        data['title'] = this.title;
        return data;
    }
}