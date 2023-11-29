import 'package:coffee/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({ super.key });

  @override
  State<TopButtons>createState() => _TopButtonsState();

}

class _TopButtonsState extends State<TopButtons> {
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
                onTap: () {},
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