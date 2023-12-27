import 'package:charts_flutter_maintained/charts_flutter_maintained.dart';
import 'package:flutter/material.dart';
import 'package:coffee/features/admin/models/sales.dart';
// import 'package:charts_common_maintained/charts_common_maintained.dart' as charts;

class CategoryItemsChart extends StatelessWidget {
  final List<Series<Sales, String>> seriesList;
  const CategoryItemsChart({
    super.key,
    required this.seriesList,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      seriesList,
      animate: true,
    );
  }
}
