// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:coffee/constants/error_handling.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/models/item.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Item>> fetchCategoryItems(
      {required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    List<Item> itemList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/items?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            itemList.add(
              Item.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return itemList;
  }

  Future<Item> fetchOfferOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    Item item = Item(
      name: '',
      description: '',
      images: [],
      category: '',
      price: 0.0,
    );
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/deal-of-the-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          item = Item.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return item;
  }
}
