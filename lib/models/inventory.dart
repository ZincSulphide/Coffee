import 'dart:convert';

import 'package:coffee/features/inventoryManagement/inventoryApi.dart';

class Inventory {
  final String id;
  final String name;
  final DateTime entryDate;
  final int expirationTimerDays;
  final double amount;

  Inventory({
    required this.id,
    required this.name,
    required this.entryDate,
    required this.expirationTimerDays,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'entryDate': entryDate.toIso8601String(),
      'expirationTimerDays': expirationTimerDays,
      'amount': amount,
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      entryDate: DateTime.parse(map['entryDate']),
      expirationTimerDays: map['expirationTimerDays'] ?? 1,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Inventory.fromJson(String source) =>
      Inventory.fromMap(json.decode(source));
}

List<Inventory> allInventory = [];
