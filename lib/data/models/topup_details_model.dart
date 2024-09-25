

class TopupDetailsModel {
  TopUpDetails? topUpDetails;

  TopupDetailsModel({this.topUpDetails});

  TopupDetailsModel.fromJson(Map<String, dynamic> json) {
    topUpDetails = json['topUpDetails'] != null
        ?  TopUpDetails.fromJson(json['topUpDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.topUpDetails != null) {
      data['topUpDetails'] = this.topUpDetails!.toJson();
    }
    return data;
  }
}

class TopUpDetails {
  dynamic id;
  dynamic status;
  dynamic featured;
  dynamic discountStatus;
  dynamic appStoreLink;
  dynamic playStoreLink;
  dynamic image;
  dynamic thumb;
  dynamic instructionImage;
  dynamic discountType;
  dynamic discountAmount;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic detailsRoute;
  dynamic imgPath;
  dynamic type;
  Details? details;
  List<ActiveServices>? activeServices;

  TopUpDetails(
      {this.id,
      this.status,
      this.featured,
      this.discountStatus,
      this.appStoreLink,
      this.playStoreLink,
      this.image,
      this.thumb,
      this.instructionImage,
      this.discountType,
      this.discountAmount,
      this.createdAt,
      this.updatedAt,
      this.detailsRoute,
      this.imgPath,
      this.type,
      this.details,
      this.activeServices});

  TopUpDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    featured = json['featured'];
    discountStatus = json['discount_status'];
    appStoreLink = json['appStoreLink'];
    playStoreLink = json['playStoreLink'];
    image = json['image'];
    thumb = json['thumb'];
    instructionImage = json['instruction_image'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    detailsRoute = json['detailsRoute'];
    imgPath = json['imgPath'];
    type = json['type'];
    details =
        json['details'] != null ?  Details.fromJson(json['details']) : null;
    if (json['active_services'] != null) {
      activeServices = <ActiveServices>[];
      json['active_services'].forEach((v) {
        activeServices!.add( ActiveServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['featured'] = this.featured;
    data['discount_status'] = this.discountStatus;
    data['appStoreLink'] = this.appStoreLink;
    data['playStoreLink'] = this.playStoreLink;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['instruction_image'] = this.instructionImage;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
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
  dynamic categoryId;
  dynamic name;
  dynamic details;
  dynamic instruction;

  Details({this.categoryId, this.name, this.details, this.instruction});

  Details.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    details = json['details'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['details'] = this.details;
    data['instruction'] = this.instruction;
    return data;
  }
}

class ActiveServices {
  dynamic id;
  dynamic categoryId;
  dynamic name;
  dynamic price;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  ActiveServices(
      {this.id,
      this.categoryId,
      this.name,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt});

  ActiveServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
