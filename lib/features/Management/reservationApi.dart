import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/reservation.dart';
import 'package:coffee/constants/global_variables.dart';
import 'dart:convert';

class reservationApi {
  static addReservation(
      String username, DateTime date, int slot, int table) async {
    var url = Uri.parse("${uri}/api/reservation/add");
    try {
      final response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "username": username,
            "Date": date.toIso8601String(),
            "slot": slot,
            "table": table
          }));
      print('bababa');
      allReservations.add(Reservation.fromMap(json.decode(response.body)));
    } catch (e) {
      print("Error: $e");
    }
  }

  static removeReservation(Reservation toRemove) async {
    var url = Uri.parse("${uri}/api/Reservation/delete/");
    try {
      final response = await http.delete(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: toRemove);
      allReservations.removeWhere((element) => element.id == toRemove.id);
      print("REMOVED SUCCESSFULLY");
      print(response);
    } catch (e) {
      print("Error: $e");
    }
  } // does not rmeove from the list

  static getAllReservation() async {
    var url = Uri.parse("${uri}/api/reservation/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        allReservations =
            jsonList.map((json) => Reservation.fromJson(json)).toList();

        // print results
        print("AllReservation: ");
        for (int i = 0; i < allReservations.length; i++) {
          print(allReservations[i].username);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static updateReservation(Reservation toUpdate) async {
    var url = Uri.parse("${uri}/api/Reservation/update/");
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

  static List<List<bool>> getFreeSlots(DateTime date) {
    // Assuming there are 10 tables and 12 slots
    List<List<bool>> free = List.generate(10, (index) => List.filled(12, true));

    for (int i = 0; i < allReservations.length; i++) {
      Reservation reservation = allReservations[i];

      // Check if the reservation date matches the parameter date
      if (reservation.date.year == date.year &&
          reservation.date.month == date.month &&
          reservation.date.day == date.day) {
        // Set the corresponding table-slot pair to false
        free[reservation.table - 1][reservation.slot - 1] = false;
      }
    }

    return free;
  }
}
