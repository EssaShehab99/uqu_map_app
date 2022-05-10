class Schedule {
  String? id;
  String? lectureId;
  String? lectureName;
  String? startDateTime;
  String? endDateTime;
  String? addByAdminId;
  String? addByAdminUserName;
  String? lecturerId;
  String? lecturerName;

  Schedule({
    this.id,
    this.lectureId,
    this.lectureName,
    this.startDateTime,
    this.endDateTime,
    this.addByAdminId,
    this.addByAdminUserName,
    this.lecturerId,
    this.lecturerName,
  });

  Schedule.fromJson(Map<String, dynamic> json){
    id = json['id'];
    lectureId = json['lectureId'];
    lectureName = json['lectureName'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    addByAdminId = json['addByAdminId'];
    addByAdminUserName = json['addByAdminUserName'];
    lectureId = json['lectureId'];
    lecturerName = json['lecturerName'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lectureId'] = lectureId;
    data['lectureName'] = lectureName;
    data['startDateTime'] = startDateTime;
    data['endDateTime'] = endDateTime;
    data['addByAdminId'] = addByAdminId;
    data['addByAdminUserName'] = addByAdminUserName;

    data['lectureId'] = lectureId;
    data['lecturerName'] = lecturerName;

    return data;
  }

}