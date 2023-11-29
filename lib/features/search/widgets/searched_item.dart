import 'package:coffee/common/widgets/star.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

class SearchedItem extends StatelessWidget {
  final Item item;
  const SearchedItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    double avgRating = 0;
    double totalRating = 0;
    for(int i = 0; i < item.rating!.length; i++) {
      totalRating += item.rating![i].rating; 
    }
    if(totalRating != 0) {
      avgRating = totalRating / item.rating!.length;
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                item.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Stars(
                      rating: avgRating,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${item.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
