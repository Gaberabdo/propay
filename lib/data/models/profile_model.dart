class ProfileModel {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? userLevel;
  String? address;
  String? createDate;
  String? balance;
  String? active;
  String? verCode;
  String? verified;
  Null? verCodeDate;
  String? token;
  String? canCharge;
  String? fCMToken;
  Null? resetPassCode;
  String? userConnectedId;

  ProfileModel(
      {this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.password,
        this.userLevel,
        this.address,
        this.createDate,
        this.balance,
        this.active,
        this.verCode,
        this.verified,
        this.verCodeDate,
        this.token,
        this.canCharge,
        this.fCMToken,
        this.resetPassCode,
        this.userConnectedId});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    userLevel = json['user_level'];
    address = json['address'];
    createDate = json['create_date'];
    balance = json['balance'];
    active = json['active'];
    verCode = json['ver_code'];
    verified = json['verified'];
    verCodeDate = json['ver_code_date'];
    token = json['token'];
    canCharge = json['can_charge'];
    fCMToken = json['FCM_token'];
    resetPassCode = json['reset_pass_code'];
    userConnectedId = json['user_connected_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['user_level'] = this.userLevel;
    data['address'] = this.address;
    data['create_date'] = this.createDate;
    data['balance'] = this.balance;
    data['active'] = this.active;
    data['ver_code'] = this.verCode;
    data['verified'] = this.verified;
    data['ver_code_date'] = this.verCodeDate;
    data['token'] = this.token;
    data['can_charge'] = this.canCharge;
    data['FCM_token'] = this.fCMToken;
    data['reset_pass_code'] = this.resetPassCode;
    data['user_connected_id'] = this.userConnectedId;
    return data;
  }
}