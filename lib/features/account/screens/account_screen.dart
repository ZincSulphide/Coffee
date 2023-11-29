import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/account/widgets/below_app_bar.dart';
import 'package:coffee/features/account/widgets/orders.dart';
import 'package:coffee/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize( 
        preferredSize: const Size.fromHeight(60),
        child: AppBar( 
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/coffee-cup.png', 
                width: 50, 
                height: 45,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 30
                    ),
                  ),
                  Icon(
                    Icons.search,
                    size: 30,
                  )
                ]),
            )
          ]
          ),
        ),
      ),
      body: const Column(
        children: [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20,),
          Orders()
        ],
      )
    );
  }
}