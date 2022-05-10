class Noticeboard {

  String? id;
  String? noticeboardId;
  String? noticeTitle;
  String? noticeBody;
  String? teacherNote;
  String? addByAdminId;
  String? addByAdminUserName;

  Noticeboard({
    this.id,
    this.noticeboardId,
    this.noticeTitle,
    this.noticeBody,
    this.addByAdminId,
    this.teacherNote,
    this.addByAdminUserName
  });

  Noticeboard.fromJson(Map<String, dynamic> json){
    id = json['id'];
    noticeboardId = json['noticeboardId'];
    noticeTitle = json['noticeTitle'];
    noticeBody = json['noticeBody'];
    teacherNote = json['teacherNote'];
    addByAdminId = json['addByAdminId'];
    addByAdminUserName = json['addByAdminUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['noticeboardId'] = noticeboardId;
    data['noticeTitle'] = noticeTitle;
    data['noticeBody'] = noticeBody;
    data['teacherNote'] = teacherNote;
    data['addByAdminId'] = addByAdminId;
    data['addByAdminUserName'] = addByAdminUserName;
    return data;
  }
}