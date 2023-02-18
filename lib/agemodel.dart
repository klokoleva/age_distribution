class AgeModel {
  int? age;
  int? count;
  String? countryId;
  String? name;

  AgeModel({this.age, this.count, this.countryId, this.name});

  AgeModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    count = json['count'];
    countryId = json['country_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['age'] = age;
    data['count'] = count;
    data['country_id'] = countryId;
    data['name'] = name;
    return data;
  }
}
