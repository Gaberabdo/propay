class OfferListModel {
  Message? message;

  OfferListModel({this.message});

  OfferListModel.fromJson(Map<String, dynamic> json) {
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
  SellPostOffer? sellPostOffer;

  Message({this.sellPostOffer});

  Message.fromJson(Map<String, dynamic> json) {
    sellPostOffer = json['sellPostOffer'] != null
        ? new SellPostOffer.fromJson(json['sellPostOffer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellPostOffer != null) {
      data['sellPostOffer'] = this.sellPostOffer!.toJson();
    }
    return data;
  }
}

class SellPostOffer {
  List<Data>? data;

  SellPostOffer({this.data});

  SellPostOffer.fromJson(Map<String, dynamic> json) {
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
  dynamic userId;
  dynamic authorId;
  dynamic sellPostId;
  dynamic amount;
  dynamic description;
  dynamic status;
  dynamic uuid;
  dynamic attemptAt;
  dynamic paymentStatus;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic dateParse;
  User? user;
  SellPost? sellPost;

  Data(
      {this.id,
      this.userId,
      this.authorId,
      this.sellPostId,
      this.amount,
      this.description,
      this.status,
      this.uuid,
      this.attemptAt,
      this.paymentStatus,
      this.createdAt,
      this.updatedAt,
      this.dateParse,
      this.user,
      this.sellPost});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    authorId = json['author_id'];
    sellPostId = json['sell_post_id'];
    amount = json['amount'];
    description = json['description'];
    status = json['status'];
    uuid = json['uuid'];
    attemptAt = json['attempt_at'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dateParse = json['dateParse'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    sellPost = json['sell_post'] != null
        ? new SellPost.fromJson(json['sell_post'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['author_id'] = this.authorId;
    data['sell_post_id'] = this.sellPostId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['status'] = this.status;
    data['uuid'] = this.uuid;
    data['attempt_at'] = this.attemptAt;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['dateParse'] = this.dateParse;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.sellPost != null) {
      data['sell_post'] = this.sellPost!.toJson();
    }
    return data;
  }
}

class User {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic referralId;
  dynamic languageId;
  dynamic email;
  dynamic countryCode;
  dynamic phoneCode;
  dynamic phone;
  dynamic balance;
  dynamic image;
  dynamic address;
  dynamic provider;
  dynamic providerId;
  dynamic status;
  dynamic identityVerify;
  dynamic addressVerify;
  dynamic twoFa;
  dynamic twoFaVerify;
  dynamic twoFaCode;
  dynamic emailVerification;
  dynamic smsVerification;
  dynamic verifyCode;
  dynamic sentAt;
  dynamic lastLogin;
  dynamic lastSeen;
  dynamic emailVerifiedAt;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic fullname;
  dynamic mobile;
  dynamic imgPath;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.username,
      this.referralId,
      this.languageId,
      this.email,
      this.countryCode,
      this.phoneCode,
      this.phone,
      this.balance,
      this.image,
      this.address,
      this.provider,
      this.providerId,
      this.status,
      this.identityVerify,
      this.addressVerify,
      this.twoFa,
      this.twoFaVerify,
      this.twoFaCode,
      this.emailVerification,
      this.smsVerification,
      this.verifyCode,
      this.sentAt,
      this.lastLogin,
      this.lastSeen,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.fullname,
      this.mobile,
      this.imgPath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    referralId = json['referral_id'];
    languageId = json['language_id'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    balance = json['balance'];
    image = json['image'];
    address = json['address'];
    provider = json['provider'];
    providerId = json['provider_id'];
    status = json['status'];
    identityVerify = json['identity_verify'];
    addressVerify = json['address_verify'];
    twoFa = json['two_fa'];
    twoFaVerify = json['two_fa_verify'];
    twoFaCode = json['two_fa_code'];
    emailVerification = json['email_verification'];
    smsVerification = json['sms_verification'];
    verifyCode = json['verify_code'];
    sentAt = json['sent_at'];
    lastLogin = json['last_login'];
    lastSeen = json['last_seen'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullname = json['fullname'];
    mobile = json['mobile'];
    imgPath = json['imgPath'];
    lastSeen = json['lastSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['username'] = this.username;
    data['referral_id'] = this.referralId;
    data['language_id'] = this.languageId;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_code'] = this.phoneCode;
    data['phone'] = this.phone;
    data['balance'] = this.balance;
    data['image'] = this.image;
    data['address'] = this.address;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['identity_verify'] = this.identityVerify;
    data['address_verify'] = this.addressVerify;
    data['two_fa'] = this.twoFa;
    data['two_fa_verify'] = this.twoFaVerify;
    data['two_fa_code'] = this.twoFaCode;
    data['email_verification'] = this.emailVerification;
    data['sms_verification'] = this.smsVerification;
    data['verify_code'] = this.verifyCode;
    data['sent_at'] = this.sentAt;
    data['last_login'] = this.lastLogin;
    data['last_seen'] = this.lastSeen;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['fullname'] = this.fullname;
    data['mobile'] = this.mobile;
    data['imgPath'] = this.imgPath;
    data['lastSeen'] = this.lastSeen;
    return data;
  }
}

class SellPost {
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

  SellPost(
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

  SellPost.fromJson(Map<String, dynamic> json) {
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


