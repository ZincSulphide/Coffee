import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map(
        (i) {
        return Builder(
          builder: (BuildContext context) => Image.asset(i,
          fit: BoxFit.cover,),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}