import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/account/widgets/single_item.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  //temp lst
  List<String> list = [
    
      'https://images.app.goo.gl/n1z1bSsNKhcE73cn8',
      'https://images.app.goo.gl/n1z1bSsNKhcE73cn8',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15,),
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
              padding: const EdgeInsets.only(right: 15,),
              child: Text(
                'See All',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor
                ),
              ),
            ),
          ]
        ),
        Container(
            height: 380,
            padding: const EdgeInsets.only(left: 10, right: 0, top: 20),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:list.length,
              itemBuilder: (context, index)  {
                return SingleItem(image: list[index],);
              }
            ),

          )
      ],
    );
      
  }
}