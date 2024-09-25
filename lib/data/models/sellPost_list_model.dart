class SellpostListModel {
  Message? message;

  SellpostListModel({this.message});

  SellpostListModel.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;

  Message({this.data});

  Message.fromJson(Map<String, dynamic> json) {
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
  dynamic paymentStatus;
  dynamic category;
  dynamic title;
  dynamic price;
  dynamic currency;
  dynamic symbol;
  dynamic status;
  dynamic dateTime;

  Data(
      {this.id,
      this.paymentStatus,
      this.category,
      this.title,
      this.price,
      this.currency,
      this.symbol,
      this.status,
      this.dateTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    paymentStatus = json['paymentStatus'] ?? "";
    category = json['category'] ?? "";
    title = json['title'] ?? "";
    price = json['price'] ?? "";
    currency = json['currency'] ?? "";
    symbol = json['symbol'] ?? "";
    status = json['status'] ?? "";
    dateTime = json['dateTime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentStatus'] = this.paymentStatus;
    data['category'] = this.category;
    data['title'] = this.title;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['status'] = this.status;
    data['dateTime'] = this.dateTime;
    return data;
  }
}
