

class VoucherDetailsModel {
  VoucherDetails? voucherDetails;

  VoucherDetailsModel({this.voucherDetails});

  VoucherDetailsModel.fromJson(Map<String, dynamic> json) {
    voucherDetails = json['voucherDetails'] != null
        ? new VoucherDetails.fromJson(json['voucherDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.voucherDetails != null) {
      data['voucherDetails'] = this.voucherDetails!.toJson();
    }
    return data;
  }
}

class VoucherDetails {
  dynamic id;
  dynamic image;
  dynamic thumb;
  dynamic discountType;
  dynamic discountAmount;
  dynamic discountStatus;
  dynamic featured;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic detailsRoute;
  dynamic imgPath;
  dynamic type;
  Details? details;
  List<ActiveServices>? activeServices;

  VoucherDetails(
      {this.id,
      this.image,
      this.thumb,
      this.discountType,
      this.discountAmount,
      this.discountStatus,
      this.featured,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.detailsRoute,
      this.imgPath,
      this.type,
      this.details,
      this.activeServices});

  VoucherDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    thumb = json['thumb'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    discountStatus = json['discount_status'];
    featured = json['featured'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    detailsRoute = json['detailsRoute'];
    imgPath = json['imgPath'];
    type = json['type'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
    if (json['active_services'] != null) {
      activeServices = <ActiveServices>[];
      json['active_services'].forEach((v) {
        activeServices!.add(new ActiveServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['discount_status'] = this.discountStatus;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['detailsRoute'] = this.detailsRoute;
    data['imgPath'] = this.imgPath;
    data['type'] = this.type;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.activeServices != null) {
      data['active_services'] =
          this.activeServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  dynamic gameVouchersId;
  dynamic name;
  dynamic details;

  Details({this.gameVouchersId, this.name, this.details});

  Details.fromJson(Map<String, dynamic> json) {
    gameVouchersId = json['game_vouchers_id'];
    name = json['name'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_vouchers_id'] = this.gameVouchersId;
    data['name'] = this.name;
    data['details'] = this.details;
    return data;
  }
}

class ActiveServices {
  dynamic id;
  dynamic gameVouchersId;
  dynamic name;
  dynamic price;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic statusMessage;
  dynamic editRoute;
  dynamic serviceInfoRoute;
  List<VoucherActiveCodes>? voucherActiveCodes;

  ActiveServices(
      {this.id,
      this.gameVouchersId,
      this.name,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.statusMessage,
      this.editRoute,
      this.serviceInfoRoute,
      this.voucherActiveCodes});

  ActiveServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameVouchersId = json['game_vouchers_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statusMessage = json['statusMessage'];
    editRoute = json['editRoute'];
    serviceInfoRoute = json['serviceInfoRoute'];
    if (json['voucher_active_codes'] != null) {
      voucherActiveCodes = <VoucherActiveCodes>[];
      json['voucher_active_codes'].forEach((v) {
        voucherActiveCodes!.add(new VoucherActiveCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_vouchers_id'] = this.gameVouchersId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['statusMessage'] = this.statusMessage;
    data['editRoute'] = this.editRoute;
    data['serviceInfoRoute'] = this.serviceInfoRoute;
    if (this.voucherActiveCodes != null) {
      data['voucher_active_codes'] =
          this.voucherActiveCodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VoucherActiveCodes {
  dynamic id;
  dynamic voucherId;
  dynamic voucherServiceId;
  dynamic code;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  VoucherActiveCodes(
      {this.id,
      this.voucherId,
      this.voucherServiceId,
      this.code,
      this.status,
      this.createdAt,
      this.updatedAt});

  VoucherActiveCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voucherId = json['voucher_id'];
    voucherServiceId = json['voucher_service_id'];
    code = json['code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voucher_id'] = this.voucherId;
    data['voucher_service_id'] = this.voucherServiceId;
    data['code'] = this.code;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
