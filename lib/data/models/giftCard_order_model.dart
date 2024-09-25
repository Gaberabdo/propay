class Game {
  String? id;
  String? name;
  String? image;
  String? active;
  String? aDSL;
  String? date;

  Game({this.id, this.name, this.image, this.active, this.aDSL, this.date});

  Game.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    active = json['active'];
    aDSL = json['ADSL'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['active'] = this.active;
    data['ADSL'] = this.aDSL;
    data['date'] = this.date;
    return data;
  }
}

class SubCat {
  String? id;
  String? name;
  String? arabicName;
  String? image;
  String? catId;
  String? active;
  String? buttons;
  String? auto;
  String? balancesId;
  String? userprevid;
  String? userprevsubcatid;
  String? percent;

  SubCat(
      {this.id,
      this.name,
      this.arabicName,
      this.image,
      this.catId,
      this.active,
      this.buttons,
      this.auto,
      this.balancesId,
      this.userprevid,
      this.userprevsubcatid,
      this.percent});

  SubCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arabicName = json['arabic_name'];
    image = json['image'];
    catId = json['cat_id'];
    active = json['active'];
    buttons = json['buttons'];
    auto = json['auto'];
    balancesId = json['balances_id'];
    userprevid = json['userprevid'];
    userprevsubcatid = json['userprevsubcatid'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['arabic_name'] = this.arabicName;
    data['image'] = this.image;
    data['cat_id'] = this.catId;
    data['active'] = this.active;
    data['buttons'] = this.buttons;
    data['auto'] = this.auto;
    data['balances_id'] = this.balancesId;
    data['userprevid'] = this.userprevid;
    data['userprevsubcatid'] = this.userprevsubcatid;
    data['percent'] = this.percent;
    return data;
  }
}
