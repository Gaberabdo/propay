import 'package:gamers_arena/utils/app_constants.dart';

class PhotoCarusel {
  bool? status;
  String? msg;
  String? token;
  List<DataSlider>? data;

  PhotoCarusel({this.status, this.msg, this.token, this.data});

  PhotoCarusel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    token = json['token'];
    if (json['data'] != null) {
      data = <DataSlider>[];
      json['data'].forEach((v) {
        data!.add(new DataSlider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataSlider {
  String? id;
  String? photo;
  String? active;

  DataSlider({this.id, this.photo, this.active});

  DataSlider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = PHPENDPOINT.sliderImage + json['photo'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['active'] = this.active;
    return data;
  }
}
