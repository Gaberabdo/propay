import 'dart:convert';

class Transaction {
  String id;
  String subcatId;
  String userId;
  String type;
  Map<String, dynamic> inputs;
  String adminId;
  String bill;
  String pay;
  String cost;
  String result;
  String finished;
  String createdDate;
  String? finishedDate;
  String askOrderSent;
  String balanceBefore;
  String balanceAfter;
  String name;
  String arabicName;
  String catName;
  String color; // Add this line if color is part of the data

  Transaction({
    required this.id,
    required this.subcatId,
    required this.userId,
    required this.type,
    required this.inputs,
    required this.adminId,
    required this.bill,
    required this.pay,
    required this.cost,
    required this.result,
    required this.finished,
    required this.createdDate,
    this.finishedDate,
    required this.askOrderSent,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.name,
    required this.arabicName,
    required this.catName,
    required this.color, // Initialize the color property
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      subcatId: json['subcat_id'],
      userId: json['user_id'],
      type: json['type'],
      inputs: jsonDecode(json['inputs']),
      adminId: json['admin_id'],
      bill: json['bill'],
      pay: json['pay'],
      cost: json['cost'],
      result: json['result'],
      finished: json['finished'],
      createdDate: json['created_date'],
      finishedDate: json['finished_date'],
      askOrderSent: json['ask_order_sent'],
      balanceBefore: json['balance_before'],
      balanceAfter: json['balance_after'],
      name: json['name'],
      arabicName: json['arabic_name'],
      catName: json['cat_name'],
      color: json['finished_date'] == null
          ? 'default'
          : 'success', // Handle missing color
    );
  }
}
