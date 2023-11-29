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

class SearchServices {
  Future<List<Item>> fetchSearchedItems({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    List<Item> itemList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/items/search/$searchQuery'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

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
}
