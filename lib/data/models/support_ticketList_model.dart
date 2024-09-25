class SupportTicketListModel {
  Message? message;

  SupportTicketListModel({this.message});

  SupportTicketListModel.fromJson(Map<String, dynamic> json) {
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
  String? ticket;
  String? subject;
  String? status;
  String? lastReply;

  Data({this.ticket, this.subject, this.status, this.lastReply});

  Data.fromJson(Map<String, dynamic> json) {
    ticket = json['ticket'];
    subject = json['subject'];
    status = json['status'];
    lastReply = json['lastReply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket'] = this.ticket;
    data['subject'] = this.subject;
    data['status'] = this.status;
    data['lastReply'] = this.lastReply;
    return data;
  }
}
