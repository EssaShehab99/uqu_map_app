class Attendance {
  String? id;
  String? studentId;
  List<UserAttendance>? userAttendance;

  Attendance({this.id, this.studentId, this.userAttendance});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['studentId'];

    if (json['userAttendance'] != null) {
      userAttendance = <UserAttendance>[];
      json['userAttendance'].forEach((v) {
        userAttendance!.add( UserAttendance.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['studentId'] = studentId;

    if (this.userAttendance != null) {
      data['userAttendance'] = this.userAttendance!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class UserAttendance {
  String? dateTime;
  String? checkInStatus;

  UserAttendance({this.dateTime, this.checkInStatus});

  UserAttendance.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    checkInStatus = json['checkInStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['checkInStatus'] = checkInStatus;

    return data;
  }
}
