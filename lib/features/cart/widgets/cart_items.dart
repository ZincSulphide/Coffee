import 'package:coffee/features/cart/services/cart_services.dart';
import 'package:coffee/features/item_details/services/item_details_services.dart';
import 'package:coffee/models/item.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final int index;
  const CartItem({super.key, required this.index});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final ItemDetailsServices itemDetailsServices = ItemDetailsServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity(Item item) {
    itemDetailsServices.addToCart(
      context: context,
      item: item,
    );
  }

  void decreaseQuantity(Item item) {
    cartServices.removeFromCart(
      context: context,
      item: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCart = context.watch<UserProvider>().user.cart[widget.index];
    final item = Item.fromMap(itemCart['item']);
    final quantity = itemCart['quantity'];
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
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      '\$${item.price}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(item),
                      child: Container(
                        width: 35,
                        height: 22,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: 35,
                        height: 22,
                        alignment: Alignment.center,
                        child: Text(quantity.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(item),
                      child: Container(
                        width: 35,
                        height: 22,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
