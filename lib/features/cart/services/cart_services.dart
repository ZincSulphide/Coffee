// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:coffee/constants/error_handling.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/models/item.dart';
import 'package:coffee/models/user.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Item item,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${item.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  
}