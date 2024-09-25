class IdPurchaseModel {
  Message? message;

  IdPurchaseModel({this.message});

  IdPurchaseModel.fromJson(Map<String, dynamic> json) {
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
  dynamic trx;
  dynamic category;
  dynamic title;
  dynamic amount;
  dynamic discount;
  dynamic currency;
  dynamic symbol;
  dynamic dateTime;

  Data(
      {this.trx,
      this.category,
      this.title,
      this.amount,
      this.discount,
      this.currency,
      this.symbol,
      this.dateTime});

  Data.fromJson(Map<String, dynamic> json) {
    trx = json['trx'] ?? "";
    category = json['category'] ?? "";
    title = json['title'] ?? "";
    amount = json['amount'] ?? "";
    discount = json['discount'] ?? "";
    currency = json['currency'] ?? "";
    symbol = json['symbol'] ?? "";
    dateTime = json['dateTime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trx'] = this.trx;
    data['category'] = this.category;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['dateTime'] = this.dateTime;
    return data;
  }
}
