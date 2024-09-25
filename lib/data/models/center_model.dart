class CenterModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String mobile;
  final String dateTime;
  final String active;

  CenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.mobile,
    required this.dateTime,
    required this.active,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      mobile: json['mobile'],
      dateTime: json['date_time'],
      active: json['active'],
    );
  }
}