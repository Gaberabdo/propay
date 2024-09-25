// Data item model
class SubCatItem {
  final String id;
  final String englishName;
  final String arabicName;
  final String type;
  final List<DropdownData>? data;
  final String percent;

  SubCatItem({
    required this.id,
    required this.englishName,
    required this.arabicName,
    required this.type,
    this.data,
    required this.percent,
  });

  factory SubCatItem.fromJson(Map<String, dynamic> json) {
    return SubCatItem(
      id: json['id'],
      englishName: json['english_name'],
      arabicName: json['arabic_name'],
      type: json['type'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => DropdownData.fromJson(item))
          .toList()
          : null,
      percent: json['percent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english_name': englishName,
      'arabic_name': arabicName,
      'type': type,
      'data': data?.map((item) => item.toJson()).toList(),
      'percent': percent,
    };
  }
}

// Dropdown data model
class DropdownData {
  final String id;
  final String dropdownId;
  final String name;
  final String bill;
  final double cost;

  DropdownData({
    required this.id,
    required this.dropdownId,
    required this.name,
    required this.bill,
    required this.cost,
  });

  factory DropdownData.fromJson(Map<String, dynamic> json) {
    return DropdownData(
      id: json['id'],
      dropdownId: json['dropdown_id'],
      name: json['name'],
      bill: json['bill'],
      cost: json['cost'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dropdown_id': dropdownId,
      'name': name,
      'bill': bill,
      'cost': cost,
    };
  }
}
