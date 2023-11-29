import 'dart:convert';

import 'package:coffee/models/rating.dart';

class Item {
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final double price;
  String? id;
  final List<Rating>? rating;

  Item({
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'rating': rating,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        images: List<String>.from(map['images']),
        category: map['category'] ?? '',
        price: map['price']?.toDouble() ?? 0.0,
        id: map['_id'],
        rating: map['ratings'] != null
            ? List<Rating>.from(
                map['ratings']?.map(
                  (x) => Rating.fromMap(x),
                ),
              )
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  //rating
}
