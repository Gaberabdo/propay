class WithdrawLogModel {
  Message? message;

  WithdrawLogModel({this.message});

  WithdrawLogModel.fromJson(Map<String, dynamic> json) {
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
  dynamic amount;
  dynamic charge;
  dynamic currency;
  dynamic symbol;
  dynamic status;
  dynamic time;
  dynamic adminFeedback;

  Data(
      {this.transactionId,
      this.gateway,
      this.amount,
      this.charge,
      this.currency,
      this.symbol,
      this.status,
      this.time,
      this.adminFeedback});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    gateway = json['gateway'];
    amount = json['amount'];
    charge = json['charge'];
    currency = json['currency'];
    symbol = json['symbol'];
    status = json['status'];
    time = json['time'];
    adminFeedback = json['adminFeedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['gateway'] = this.gateway;
    data['amount'] = this.amount;
    data['charge'] = this.charge;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['status'] = this.status;
    data['time'] = this.time;
    data['adminFeedback'] = this.adminFeedback;
    return data;
  }
}
