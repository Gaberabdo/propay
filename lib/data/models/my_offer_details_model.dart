class MyOfferDetailsModel {
  dynamic id;
  dynamic userId;
  dynamic categoryId;
  dynamic title;
  dynamic price;
  dynamic details;
  dynamic comments;
  dynamic sellCharge;
  List<dynamic>? image;
  dynamic status;
  dynamic lockFor;
  dynamic lockAt;
  dynamic paymentLock;
  dynamic paymentStatus;
  dynamic paymentUuid;
  dynamic createdAt;
  dynamic updatedAt;
  List<dynamic>? imagePath;

  MyOfferDetailsModel(
      {this.id,
      this.userId,
      this.categoryId,
      this.title,
      this.price,
      this.details,
      this.comments,
      this.sellCharge,
      this.image,
      this.status,
      this.lockFor,
      this.lockAt,
      this.paymentLock,
      this.paymentStatus,
      this.paymentUuid,
      this.createdAt,
      this.updatedAt,
      this.imagePath});

  MyOfferDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    title = json['title'];
    price = json['price'];
    details = json['details'];
    comments = json['comments'];
    sellCharge = json['sell_charge'];
    image = json['image'].cast<String>();
    status = json['status'];
    lockFor = json['lock_for'];
    lockAt = json['lock_at'];
    paymentLock = json['payment_lock'];
    paymentStatus = json['payment_status'];
    paymentUuid = json['payment_uuid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['imagePath'].cast<String>();
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
    data['image'] = this.image;
    data['status'] = this.status;
    data['lock_for'] = this.lockFor;
    data['lock_at'] = this.lockAt;
    data['payment_lock'] = this.paymentLock;
    data['payment_status'] = this.paymentStatus;
    data['payment_uuid'] = this.paymentUuid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
