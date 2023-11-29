// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:coffee/constants/error_handling.dart';
import 'package:coffee/models/user.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../constants/global_variables.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'address': address}),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );

          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all items
  Future<List<Item>> fetchAllItems(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    List<Item> itemList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-items'), headers: {
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

  void deleteItem({
    required BuildContext context,
    required Item item,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': item.id,
        }),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
