class BuyIdModel {
  Message? message;

  BuyIdModel({this.message});

  BuyIdModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  SellPost? sellPost;

  Message({this.sellPost});

  Message.fromJson(Map<String, dynamic> json) {
    sellPost = json['sellPost'] != null
        ? new SellPost.fromJson(json['sellPost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellPost != null) {
      data['sellPost'] = this.sellPost!.toJson();
    }
    return data;
  }
}

class SellPost {
  List<Data>? data;

  SellPost({this.data});

  SellPost.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic userId;
  dynamic categoryId;
  dynamic title;
  dynamic price;
  dynamic details;
  dynamic comments;
  dynamic sellCharge;
  List<dynamic>? imagePath;
  dynamic status;
  dynamic lockFor;
  dynamic lockAt;
  dynamic paymentLock;
  dynamic paymentStatus;
  dynamic paymentUuid;
  dynamic createdAt;
  dynamic updatedAt;

  Data(
      {this.id,
      this.userId,
      this.categoryId,
      this.title,
      this.price,
      this.details,
      this.comments,
      this.sellCharge,
      this.imagePath,
      this.status,
      this.lockFor,
      this.lockAt,
      this.paymentLock,
      this.paymentStatus,
      this.paymentUuid,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    title = json['title'];
    price = json['price'];
    details = json['details'];
    comments = json['comments'];
    sellCharge = json['sell_charge'];
    imagePath = json['imagePath'].cast<String>();
    status = json['status'];
    lockFor = json['lock_for'];
    lockAt = json['lock_at'];
    paymentLock = json['payment_lock'];
    paymentStatus = json['payment_status'];
    paymentUuid = json['payment_uuid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['details'] = this.details;
    data['comments'] = this.comments;
    data['sell_charge'] = this.sellCharge;
    data['imagePath'] = this.imagePath;
    data['status'] = this.status;
    data['lock_for'] = this.lockFor;
    data['lock_at'] = this.lockAt;
    data['payment_lock'] = this.paymentLock;
    data['payment_status'] = this.paymentStatus;
    data['payment_uuid'] = this.paymentUuid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
