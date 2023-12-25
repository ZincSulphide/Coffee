import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/inventory.dart';
import 'package:coffee/constants/global_variables.dart';
import 'dart:convert';

class inventoryApi {
  static addInventory(String name, int amount, int expirationDays) async {
    var url = Uri.parse("${uri}/api/inventory/add");
    try {
      final response = await http.post(url, headers: <String, String>{
        'Content-Type': 'application/json'
      }, body: {
        "name": name,
        "expirationTimer_days": expirationDays,
        "amount": amount
      });
      allInventory.add(Inventory.fromJson(json.decode(response.body)));
    } catch (e) {
      print("Error: $e");
    }
  }

  static removeInventory(Inventory toRemove) async {
    var url = Uri.parse("${uri}/api/inventory/delete/");
    try {
      final response = await http.delete(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: toRemove);
      allInventory.removeWhere((element) => element.id == toRemove.id);
      print("REMOVED SUCCESSFULLY");
      print(response);
    } catch (e) {
      print("Error: $e");
    }
  } // does not rmeove from the list

  static getAllInventory() async {
    var url = Uri.parse("${uri}/api/inventory/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        allInventory =
            jsonList.map((json) => Inventory.fromJson(json)).toList();

        // Remove expired items
        DateTime currentDate = DateTime.now();
        for (int i = 0; i < allInventory.length; i++) {
          if (currentDate.isAfter(allInventory[i].entryDate.add(
                Duration(days: allInventory[i].expirationTimerDays),
              ))) {
            await removeInventory(allInventory[i]);
            i--; // Decrement the index as the list size has changed
          }
        }
        // print results
        print("AllInventory: ");
        for (int i = 0; i < allInventory.length; i++) {
          print(allInventory[i].name);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateInventory(Inventory toUpdate) async {
    var url = Uri.parse("${uri}/api/inventory/update/");
    try {
      final response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: toUpdate);
      print("Updated SUCCESSFULLY");
      print(response);
    } catch (e) {
      print("Error: $e");
    }
  }
}
