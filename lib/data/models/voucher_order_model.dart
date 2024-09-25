// To parse this JSON data, do
//
//     final voucherOrderModel = voucherOrderModelFromJson(jsonString);

import 'dart:convert';

VoucherOrderModel voucherOrderModelFromJson(String str) => VoucherOrderModel.fromJson(json.decode(str));

String voucherOrderModelToJson(VoucherOrderModel data) => json.encode(data.toJson());

class VoucherOrderModel {
    Message? message;

    VoucherOrderModel({
        this.message,
    });

    factory VoucherOrderModel.fromJson(Map<String, dynamic> json) => VoucherOrderModel(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
    };
}

class Message {
    List<Datum>? data;

    Message({
        this.data,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    dynamic trx;
    dynamic voucher;
    dynamic service;
    dynamic price;
    dynamic currency;
    dynamic symbol;
    dynamic status;
    DateTime? dateTime;
    List<dynamic>? voucherCode;

    Datum({
        this.trx,
        this.voucher,
        this.service,
        this.price,
        this.currency,
        this.symbol,
        this.status,
        this.dateTime,
        this.voucherCode,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        trx: json["trx"] ?? '',
        voucher: json["voucher"] ?? '',
        service: json["service"] ?? '',
        price: json["price"] ?? '',
        currency: json["currency"] ?? '',
        symbol: json["symbol"] ?? '',
        status: json["status"] ?? '',
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        voucherCode: json["voucherCode"] == null ? null : List<dynamic>.from(json["voucherCode"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "trx": trx,
        "voucher": voucher,
        "service": service,
        "price": price,
        "currency": currency,
        "symbol": symbol,
        "status": status,
        "dateTime": dateTime!.toIso8601String(),
        "voucherCode": List<dynamic>.from(voucherCode!.map((x) => x)),
    };
}
