import 'package:coffee/features/account/services/account_services.dart';
import 'package:coffee/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({ super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your orders', 
              onTap: () {},
            ),
            AccountButton(
              text: 'Edit Account info', 
              onTap: () {},
            )
          ],),
          const SizedBox(height: 10,),
          Row(
            children: [
              AccountButton(
                text: 'Log Out', 
                onTap: () => AccountServices().logOut(context),
              ),
              AccountButton(
                text: 'Your Favorites', 
                onTap: () {},
              )
            ],
          )
      ],
    );
  }
}