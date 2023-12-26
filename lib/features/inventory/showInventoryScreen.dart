import 'package:coffee/features/Management/inventoryApi.dart';
import 'package:coffee/models/inventory.dart';
import 'package:flutter/material.dart';

class InventoryItem {
  final String name;
  int quantity;
  final DateTime expiryDate;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.expiryDate,
  });
}

class InventoryPage extends StatefulWidget {
  static const String routeName = '/inventory';

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<InventoryItem> inventoryItems = [];

  InventoryItem? _selectedItem;
  int _quantityAdjustment = 0;

  @override
  void initState() {
    // Populate inventoryItems from API or some source
    inventoryApi.getAllInventory();
    for (int i = 0; i < allInventory.length; i++) {
      inventoryItems.add(InventoryItem(
          name: allInventory[i].name,
          quantity: allInventory[i].amount.toInt(),
          expiryDate: DateTime.now()
              .add(Duration(days: allInventory[i].expirationTimerDays))));
    }
    inventoryItems.add(InventoryItem(
        name: 'Tomato',
        quantity: 5,
        expiryDate: DateTime.now().add(Duration(days: 14))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Items in Inventory:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (inventoryItems.isEmpty)
            Center(
              child: Text('Inventory is empty.'),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: inventoryItems.map((item) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  _selectedItem = item;
                                  _quantityAdjustment = -_quantityAdjustment;
                                  print(_quantityAdjustment);
                                  _adjustQuantity(_quantityAdjustment);
                                  _quantityAdjustment = -_quantityAdjustment;
                                },
                              ),
                              SizedBox(
                                width: 40,
                                child: Center(
                                  child: TextFormField(
                                    initialValue: _selectedItem == item
                                        ? '$_quantityAdjustment'
                                        : '0',
                                    onChanged: (value) {
                                      _quantityAdjustment =
                                          int.tryParse(value) ?? 0;
                                    },
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _selectedItem = item;
                                  // _quantityAdjustment = 1;
                                  _adjustQuantity(_quantityAdjustment);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem() async {
    final newItem = await _addItemDialog();
    if (newItem != null) {
      setState(() {
        inventoryItems.add(newItem);
      });
    }
  }

  Future<InventoryItem?> _addItemDialog() async {
    String itemName = '';
    int itemQuantity = 0;
    DateTime? itemExpiryDate;

    return showDialog<InventoryItem>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: InputDecoration(hintText: 'Enter item name'),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  itemQuantity = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(hintText: 'Enter quantity'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      itemExpiryDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  itemExpiryDate != null
                      ? 'Expiry Date: ${itemExpiryDate!.toString().substring(0, 10)}'
                      : 'Select Expiry Date',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (itemName.isNotEmpty &&
                    itemQuantity > 0 &&
                    itemExpiryDate != null) {
                  Navigator.of(context).pop(
                    InventoryItem(
                      name: itemName,
                      quantity: itemQuantity,
                      expiryDate: itemExpiryDate!,
                    ),
                  );
                } else {
                  // Handle invalid input
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _adjustQuantity(int factor) {
    if (_selectedItem != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Inventory Changes'),
            content: Text('Are you sure you want to adjust the quantity?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  setState(() {
                    _selectedItem!.quantity += factor;
                    print(_quantityAdjustment);
                    print(factor);
                    if (_selectedItem!.quantity <= 0) {
                      inventoryItems.remove(_selectedItem);
                      _selectedItem = null;
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
