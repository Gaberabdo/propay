class CreatePostCategoryListModel {
  Message? message;

  CreatePostCategoryListModel({this.message});

  CreatePostCategoryListModel.fromJson(Map<String, dynamic> json) {
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
  List<CategoryList>? categoryList;

  Message({this.categoryList});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['categoryList'] != null) {
      categoryList = <CategoryList>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  dynamic id;
  dynamic image;
  dynamic sellCharge;
  dynamic status;
  Details? details;

  CategoryList(
      {this.id, this.image, this.sellCharge, this.status, this.details});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    sellCharge = json['sell_charge'];
    status = json['status'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['sell_charge'] = this.sellCharge;
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  dynamic id;
  dynamic sellPostCategoryId;
  dynamic languageId;
  dynamic name;

  Details(
      {this.id,
      this.sellPostCategoryId,
      this.languageId,
      this.name,});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellPostCategoryId = json['sell_post_category_id'];
    languageId = json['language_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sell_post_category_id'] = this.sellPostCategoryId;
    data['language_id'] = this.languageId;
    data['name'] = this.name;
    return data;
  }
}
