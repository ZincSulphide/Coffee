import 'dart:convert';

class Reservation {
  final String id;
  final String username;
  final DateTime date;
  final int slot;
  final int table;
  final int numberOfPeople;

  Reservation({
    required this.id,
    required this.username,
    required this.date,
    required this.slot,
    required this.table,
    required this.numberOfPeople,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'date': date.toIso8601String(),
      'slot': slot,
      'table': table,
      'numberOfPeople': numberOfPeople,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      date: DateTime.parse(map['date']),
      slot: map['slot'] ?? 0,
      table: map['table'] ?? 0,
      numberOfPeople: map['numberOfPeople'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));
}

List<Reservation> allReservations = [];
