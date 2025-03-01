import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/account/services/account_services.dart';
import 'package:coffee/features/account/widgets/single_item.dart';
import 'package:coffee/features/order_details/screens/order_details.dart';
import 'package:coffee/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: const Text(
              'Your orders',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: Text(
              'See All',
              style: TextStyle(color: GlobalVariables.selectedNavBarColor),
            ),
          ),
        ]),
        Container(
          height: 170,
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            right: 0,
          ),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orders!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      OrderDetailScreen.routeName,
                      arguments: orders![index],
                    );
                  },
                  child: SingleItem(
                    image: orders![index].items[0].images[0],
                  ),
                );
              }),
        )
      ],
    );
  }
}
