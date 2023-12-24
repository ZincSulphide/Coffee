import 'package:flutter/material.dart';

class Reservation {
  final DateTime date;
  final String slot;
  final int tableNumber;
  final String userName;

  Reservation({
    required this.date,
    required this.slot,
    required this.tableNumber,
    required this.userName,
  });
}

DateTime getCurrentDateWithoutTime(DateTime DT) {
  return DateTime(DT.year, DT.month, DT.day);
}

class AdminReservationScreen extends StatefulWidget {
  static const String routeName = '/admin_reservations';

  @override
  _AdminReservationScreenState createState() => _AdminReservationScreenState();
}

class _AdminReservationScreenState extends State<AdminReservationScreen> {
// Create a DateTime object with only the date part
  DateTime selectedDate = getCurrentDateWithoutTime(DateTime.now());
  DateTime currentDate = getCurrentDateWithoutTime(DateTime.now());
  List<Reservation> reservations = [
    Reservation(
        date: getCurrentDateWithoutTime(DateTime.now()),
        slot: '10:00 - 11:00',
        tableNumber: 1,
        userName: 'User A'),
    Reservation(
        date: getCurrentDateWithoutTime(DateTime.now()),
        slot: '12:00 - 13:00',
        tableNumber: 2,
        userName: 'User B'),
    Reservation(
        date: DateTime.now().add(Duration(days: 1)),
        slot: '14:00 - 15:00',
        tableNumber: 3,
        userName: 'User C'),
    Reservation(
        date: DateTime.now(),
        slot: '16:00 - 17:00',
        tableNumber: 4,
        userName: 'User D'),
    // Add more demo data as needed
  ];

  List<Reservation> getReservationsForDate(DateTime date) {
    return reservations.where((res) => res.date == date).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Reservation> selectedReservations =
        getReservationsForDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Reservations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                    'Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  _selectDate(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Reservations for the selected date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            if (selectedReservations.isEmpty)
              Center(
                child: Text('No reservations for this date.'),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: selectedReservations.map((reservation) {
                  return ListTile(
                    title: Text(
                        'Table ${reservation.tableNumber} - ${reservation.slot}: ${reservation.userName}'),
                    // You can add more details or actions for each reservation here
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
