class PaymentLogModel {
  Message? message;

  PaymentLogModel({this.message});

  PaymentLogModel.fromJson(Map<String, dynamic> json) {
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
  dynamic transactionId;
  dynamic gateway;
  dynamic currency;
  dynamic symbol;
  dynamic amount;
  dynamic charge;
  dynamic status;
  dynamic time;

  Data(
      {this.transactionId,
      this.gateway,
      this.currency,
      this.symbol,
      this.amount,
      this.charge,
      this.status,
      this.time});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    gateway = json['gateway'];
    currency = json['currency'];
    symbol = json['symbol'];
    amount = json['amount'];
    charge = json['charge'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['gateway'] = this.gateway;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['amount'] = this.amount;
    data['charge'] = this.charge;
    data['status'] = this.status;
    data['time'] = this.time;
    return data;
  }
}
