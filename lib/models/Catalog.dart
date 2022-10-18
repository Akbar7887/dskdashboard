

class Catalog {
    String? concrete;
    String? heigth;
    int? id;
    String? length;
    String? mass;
    String? name;
    String? volume;
    String? weigth;
    String? description;
    String? imagepath;

    Catalog({
        this.concrete,
        this.heigth,
        this.id,
        this.length,
        this.mass,
        this.name,
        this.volume,
        this.weigth,
        this.description,
    this.imagepath});

    factory Catalog.fromJson(Map<String, dynamic> json) {
        return Catalog(
            concrete: json['concrete'],
            heigth: json['heigth'], 
            id: json['id'], 
            length: json['length'], 
            mass: json['mass'], 
            name: json['name'], 
            volume: json['volume'], 
            weigth: json['weigth'],
            description: json['description']

        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['concrete'] = this.concrete;
        data['heigth'] = this.heigth;
        data['id'] = this.id;
        data['length'] = this.length;
        data['mass'] = this.mass;
        data['name'] = this.name;
        data['volume'] = this.volume;
        data['weigth'] = this.weigth;
        data['description'] = this.description;

        return data;
    }
}