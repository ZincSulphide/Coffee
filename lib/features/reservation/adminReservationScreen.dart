import 'package:coffee/features/Management/reservationApi.dart';
import 'package:coffee/models/reservation.dart';
import 'package:flutter/material.dart';

List<String> predefinedSlots = [
  '10:00 - 11:00',
  '11:00 - 12:00',
  '12:00 - 13:00',
  '13:00 - 14:00',
  '14:00 - 15:00',
  '15:00 - 16:00',
  '16:00 - 17:00',
  '17:00 - 18:00',
  '18:00 - 19:00',
  '19:00 - 20:00',
  '20:00 - 21:00',
  '21:00 - 22:00',
  // Adjust or add more predefined slots as needed
];

class ReservationClass {
  final DateTime date;
  final String slot;
  final int tableNumber;
  final String userName;

  ReservationClass({
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
  List<ReservationClass> reservations = [];
  @override
  void initState() {
    // TODO: implement initState
    reservationApi.getAllReservation();
    for (int i = 0; i < allReservations.length; i++) {
      reservations.add(ReservationClass(
          date: getCurrentDateWithoutTime(allReservations[i].date),
          slot: predefinedSlots[allReservations[i].slot],
          tableNumber: allReservations[i].table,
          userName: allReservations[i].username));
      print(allReservations[i].date); //check
    }
    reservations.add(ReservationClass(
        date: getCurrentDateWithoutTime(DateTime.now()),
        slot: '10:00 - 11:00',
        tableNumber: 1,
        userName: 'User A'));

    reservations.add(
      ReservationClass(
          date: getCurrentDateWithoutTime(DateTime.now()),
          slot: '12:00 - 13:00',
          tableNumber: 2,
          userName: 'User B'),
    );
    super.initState();
  }

// Create a DateTime object with only the date part
  DateTime currentDate = getCurrentDateWithoutTime(DateTime.now());
  DateTime selectedDate = DateTime.now();

  List<ReservationClass> getReservationsForDate(DateTime date) {
    return reservations.where((res) => res.date == date).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ReservationClass> selectedReservations =
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
        selectedDate = getCurrentDateWithoutTime(picked);
      });
      print(selectedDate);
    }
  }
}
