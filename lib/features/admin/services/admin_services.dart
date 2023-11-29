// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:coffee/constants/error_handling.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../constants/global_variables.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminServices {
  void addItemToMenu({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    try {
      final cloudinary = CloudinaryPublic('ddkfw2vmh', 'smwampec');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res =
            await cloudinary.uploadFile(CloudinaryFile.fromFile(
          images[i].path,
          folder: name,
        ));
        imageUrls.add(res.secureUrl);
      }

      Item item = Item(
        name: name,
        description: description,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-item'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: item.toJson(),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added Successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all items
  Future<List<Item>> fetchAllItems(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false,);
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
