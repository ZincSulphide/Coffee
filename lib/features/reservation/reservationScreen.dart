import 'package:flutter/material.dart';
import '../Management/reservationApi.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ReservationScreen extends StatefulWidget {
  static const String routeName = '/reservation';

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<String> selectedSlots = [];
  DateTime? selectedDate;
  int? selectedTable;

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

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  List<DateTime> generateDateList() {
    List<DateTime> dateList = [];
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      dateList.add(
          DateTime(currentDate.year, currentDate.month, currentDate.day + i));
    }
    return dateList;
  }

  Widget buildSlotButton(String slot) {
    // selectedSlots.insert()
    bool isSlotSelected = selectedSlots.contains(slot);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSlotSelected) {
            selectedSlots.remove(slot);
          } else {
            selectedSlots.add(slot);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSlotSelected ? Colors.grey : Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          slot,
          style: TextStyle(
            color: isSlotSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    List<DateTime> dateList = generateDateList();
    List<Map<String, dynamic>> tables = [
      {'number': 1, 'capacity': '(Recommended for Up to 4 People)'},
      {'number': 2, 'capacity': '(Recommended for Up to 4 People)'},
      {'number': 3, 'capacity': '(Recommended for Up to 6 People)'},
      {'number': 4, 'capacity': '(Recommended for Up to 6 People)'},
    ];

    Future<void> _showConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Reservation'),
            content: Text('Do you want to confirm your reservation?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Handle the confirmation action here
                  // You can call your API or perform any other necessary actions
                  // Handle selected date, table, and slots
                  print('Selected Date: $selectedDate');
                  print('Selected Table: $selectedTable');
                  print('Selected Slots: $selectedSlots');

                  for (int i = 3; i < selectedSlots.length; i++) {
                    reservationApi.addReservation(
                        user.name,
                        selectedDate!,
                        predefinedSlots.indexOf(selectedSlots[i]),
                        selectedTable!);

                    print(user.name);
                    print(selectedDate);
                    print(predefinedSlots.indexOf(selectedSlots[i]));
                    print(selectedTable);
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Reservation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<DateTime>(
                hint: Text('Choose the date'), // Placeholder text
                value: selectedDate,
                onChanged: (DateTime? newValue) {
                  setState(() {
                    selectedDate = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Choose the date'), // Placeholder item
                  ),
                  ...dateList.asMap().entries.map((entry) {
                    int index = entry.key;
                    DateTime date = entry.value;
                    String dayOfWeek = daysOfWeek[
                        date.weekday - 1]; // Adjust index for daysOfWeek
                    return DropdownMenuItem<DateTime>(
                      value: date,
                      key: Key('$index'), // Unique key for each item
                      child: Text(
                        '$dayOfWeek, ${date.day}/${date.month}',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<int>(
                hint: Text('Choose the table'), // Placeholder text
                value: selectedTable,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedTable = newValue!;
                  });
                  selectedSlots.add('10:00 - 11:00');
                  selectedSlots.add('11:00 - 12:00');
                  selectedSlots.add('12:00 - 13:00');
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Choose the table'), // Placeholder item
                  ),
                  ...tables.map((table) {
                    return DropdownMenuItem<int>(
                      value: table['number'],
                      child:
                          Text('Table ${table['number']} ${table['capacity']}'),
                    );
                  }).toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Slots:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              children:
                  predefinedSlots.map((slot) => buildSlotButton(slot)).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text('Confirm Selection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
