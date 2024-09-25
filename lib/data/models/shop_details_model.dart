

// To parse this JSON data, do
//
//     final shopDetails = shopDetailsFromJson(jsonString);

import 'dart:convert';

ShopDetails shopDetailsFromJson(String str) => ShopDetails.fromJson(json.decode(str));

String shopDetailsToJson(ShopDetails data) => json.encode(data.toJson());

class ShopDetails {
    dynamic currentPage;
    List<Datum>? data;

    ShopDetails({
        this.currentPage,
        this.data,
    });

    factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
        currentPage: json["current_page"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    dynamic id;
    dynamic status;
    dynamic featured;
    dynamic discountStatus;
    String? appStoreLink;
    String? playStoreLink;
    String? image;
    String? thumb;
    String? instructionImage;
    dynamic discountType;
    dynamic discountAmount;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic totalSoldCount;
    String? detailsRoute;
    String? imgPath;
    String? type;
    Details? details;

    Datum({
        this.id,
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
        this.totalSoldCount,
        this.detailsRoute,
        this.imgPath,
        this.type,
        this.details,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        featured: json["featured"],
        discountStatus: json["discount_status"],
        appStoreLink: json["appStoreLink"],
        playStoreLink: json["playStoreLink"],
        image: json["image"],
        thumb: json["thumb"],
        instructionImage: json["instruction_image"],
        discountType: json["discount_type"],
        discountAmount: json["discount_amount"],
        createdAt:json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        totalSoldCount: json["total_sold_count"],
        detailsRoute: json["detailsRoute"],
        imgPath: json["imgPath"],
        type: json["type"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "featured": featured,
        "discount_status": discountStatus,
        "appStoreLink": appStoreLink,
        "playStoreLink": playStoreLink,
        "image": image,
        "thumb": thumb,
        "instruction_image": instructionImage,
        "discount_type": discountType,
        "discount_amount": discountAmount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "total_sold_count": totalSoldCount,
        "detailsRoute": detailsRoute,
        "imgPath": imgPath,
        "type": type,
        "details": details!.toJson(),
    };
}

class Details {
    dynamic id;
    dynamic categoryId;
    dynamic languageId;
    String? name;
    String? details;
    String? instruction;
    DateTime? createdAt;
    DateTime? updatedAt;

    Details({
        this.id,
        this.categoryId,
        this.languageId,
        this.name,
        this.details,
        this.instruction,
        this.createdAt,
        this.updatedAt,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        name: json["name"],
        details: json["details"],
        instruction: json["instruction"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "name": name,
        "details": details,
        "instruction": instruction,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}






