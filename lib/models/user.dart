class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? userName;
  String? password;
  String? role;
  String? addByAdminId;
  String? addByAdminUserName;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userName,
    this.password,
    this.role,
    this.addByAdminId,
    this.addByAdminUserName
  });

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    userName = json['userName'];
    password = json['password'];
    role = json['role'];
    addByAdminId = json['addByAdminId'];
    addByAdminUserName = json['addByAdminUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['userName'] = userName;
    data['password'] = password;
    data['role'] = role;
    data['addByAdminId'] = addByAdminId;
    data['addByAdminUserName'] = addByAdminUserName;

    return data;
  }

}