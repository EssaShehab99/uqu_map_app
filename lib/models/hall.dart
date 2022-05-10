class Hall{
  String? id;
  String? hallId;
  String? hallName;
  String? capacity;
  String? freeSeats;
  String? status;
  String? reservedByUserId;
  String? reservedByUserName;
  String? addByAdminId;
  String? addByAdminUserName;
  String? reservedByLecturerId;
  String? reservedByLecturerName;

  Hall({
    this.id,
    this.hallId,
    this.hallName,
    this.capacity,
    this.freeSeats,
    this.status,
    this.reservedByUserId,
    this.reservedByUserName,
    this.addByAdminId,
    this.addByAdminUserName,
    this.reservedByLecturerId,
    this.reservedByLecturerName
  });

  Hall.fromJson(Map<String, dynamic> json){
    id = json['id'];
    hallId = json['hallId'];
    hallName = json['hallName'];
    capacity = json['capacity'];
    freeSeats = json['freeSeats'];
    status = json['status'];
    reservedByUserId = json['reservedByUserId'];
    reservedByUserName = json['reservedByUserName'];
    addByAdminId = json['addByAdminId'];
    addByAdminUserName = json['addByAdminUserName'];

    reservedByLecturerId = json['reservedByLecturerId'];
    reservedByLecturerName = json['reservedByLecturerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['hallId'] = hallId;
    data['hallName'] = hallName;
    data['capacity'] = capacity;
    data['freeSeats'] = freeSeats;
    data['status'] = status;
    data['reservedByUserId'] = reservedByUserId;
    data['reservedByUserName'] = reservedByUserName;
    data['addByAdminId'] = addByAdminId;
    data['addByAdminUserName'] = addByAdminUserName;

    data['reservedByLecturerId'] = reservedByLecturerId;
    data['reservedByLecturerName'] = reservedByLecturerName;

    return data;
  }
}