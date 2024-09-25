// To parse this JSON data, do
//
//     final conversationListModel = conversationListModelFromJson(jsonString);

import 'dart:convert';

ConversationListModel conversationListModelFromJson(String str) => ConversationListModel.fromJson(json.decode(str));

String conversationListModelToJson(ConversationListModel data) => json.encode(data.toJson());

class ConversationListModel {
    Message? message;

    ConversationListModel({
        this.message,
    });

    factory ConversationListModel.fromJson(Map<String, dynamic> json) => ConversationListModel(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
    };
}

class Message {
    bool? isAuthor;
    List<SiteNotification>? siteNotifications;

    Message({
        this.isAuthor,
        this.siteNotifications,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        isAuthor: json["isAuthor"],
        siteNotifications:json["siteNotifications"] == null ? [] : List<SiteNotification>.from(json["siteNotifications"].map((x) => SiteNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isAuthor": isAuthor,
        "siteNotifications": List<dynamic>.from(siteNotifications!.map((x) => x.toJson())),
    };
}

class SiteNotification {
    dynamic id;
    dynamic sellPostId;
    dynamic offerId;
    dynamic chatableType;
    dynamic chatableId;
    dynamic description;
    dynamic isRead;
    dynamic isReadAdmin;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic formattedDate;
    Chatable? chatable;

    SiteNotification({
        this.id,
        this.sellPostId,
        this.offerId,
        this.chatableType,
        this.chatableId,
        this.description,
        this.isRead,
        this.isReadAdmin,
        this.createdAt,
        this.updatedAt,
        this.formattedDate,
        this.chatable,
    });

    factory SiteNotification.fromJson(Map<String, dynamic> json) => SiteNotification(
        id: json["id"],
        sellPostId: json["sell_post_id"],
        offerId: json["offer_id"],
        chatableType: json["chatable_type"],
        chatableId: json["chatable_id"],
        description: json["description"],
        isRead: json["is_read"],
        isReadAdmin: json["is_read_admin"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        formattedDate: json["formatted_date"],
        chatable: Chatable.fromJson(json["chatable"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sell_post_id": sellPostId,
        "offer_id": offerId,
        "chatable_type": chatableType,
        "chatable_id": chatableId,
        "description": description,
        "is_read": isRead,
        "is_read_admin": isReadAdmin,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "chatable": chatable!.toJson(),
    };
}

class Chatable {
    dynamic id;
    dynamic username;
    dynamic phone;
    dynamic image;
    dynamic fullname;
    dynamic mobile;
    dynamic imgPath;
    dynamic lastSeen;

    Chatable({
        this.id,
        this.username,
        this.phone,
        this.image,
        this.fullname,
        this.mobile,
        this.imgPath,
        this.lastSeen,
    });

    factory Chatable.fromJson(Map<String, dynamic> json) => Chatable(
        id: json["id"],
        username: json["username"],
        phone: json["phone"],
        image: json["image"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        imgPath: json["imgPath"],
        lastSeen: json["lastSeen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "phone": phone,
        "image": image,
        "fullname": fullname,
        "mobile": mobile,
        "imgPath": imgPath,
        "lastSeen": lastSeen,
    };
}
