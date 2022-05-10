class Building{
  String? id;
  String? buildingId;
  String? buildingName;
  String? lat;
  String? lang;
  String? addByAdminId;
  String? addByAdminUserName;

  Building({
    this.id,
    this.buildingId,
    this.buildingName,
    this.lat,
    this.lang,
    this.addByAdminId,
    this.addByAdminUserName
  });

  Building.fromJson(Map<String, dynamic> json){
    id = json['id'];
    buildingId = json['buildingId'];
    buildingName = json['buildingName'];
    lat = json['lat'];
    lang = json['lang'];
    addByAdminId = json['addByAdminId'];
    addByAdminUserName = json['addByAdminUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['buildingId'] = buildingId;
    data['buildingName'] = buildingName;
    data['lat'] = lat;
    data['lang'] = lang;
    data['addByAdminId'] = addByAdminId;
    data['addByAdminUserName'] = addByAdminUserName;

    return data;
  }
}