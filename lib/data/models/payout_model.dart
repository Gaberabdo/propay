class PayoutModel {
  Message? message;

  PayoutModel({this.message});

  PayoutModel.fromJson(Map<String, dynamic> json) {
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
  List<PayoutGateways>? gateways;

  Message({this.gateways});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['gateways'] != null) {
      gateways = <PayoutGateways>[];
      json['gateways'].forEach((v) {
        gateways!.add(new PayoutGateways.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gateways != null) {
      data['gateways'] = this.gateways!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GatewaysModel {
    List<PayoutGateways>? gateways;

    GatewaysModel({
        this.gateways,
    });

    factory GatewaysModel.fromJson(Map<String, dynamic> json) => GatewaysModel(
        gateways: json["message"] == null ? [] : List<PayoutGateways>.from(json["message"].map((x) => PayoutGateways.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(gateways!.map((x) => x.toJson())),
    };
}

class PayoutGateways {
  dynamic id;
  dynamic name;
  dynamic code;
  dynamic currency;
  dynamic symbol;
  dynamic conventionRate;
  dynamic minAmount;
  dynamic maxAmount;
  dynamic percentageCharge;
  dynamic fixedCharge;
  dynamic image;

  PayoutGateways(
      {this.id,
      this.name,
      this.code,
      this.currency,
      this.symbol,
      this.conventionRate,
      this.minAmount,
      this.maxAmount,
      this.percentageCharge,
      this.fixedCharge,
      this.image});

  PayoutGateways.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    currency = json['currency'];
    symbol = json['currencySymbol'];
    conventionRate = json['convention_rate'];
    minAmount = json['minimumAmount'];
    maxAmount = json['maximumAmount'];
    percentageCharge = json['percentage_charge'];
    fixedCharge = json['fixedCharge'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['convention_rate'] = this.conventionRate;
    data['min_amount'] = this.minAmount;
    data['max_amount'] = this.maxAmount;
    data['percentage_charge'] = this.percentageCharge;
    data['fixed_charge'] = this.fixedCharge;
    data['image'] = this.image;
    return data;
  }
}
