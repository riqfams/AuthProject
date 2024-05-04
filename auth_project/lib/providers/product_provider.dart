import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/product.dart';

class ProductProvider extends ChangeNotifier {

  String baseUrl = "https://auth-project-eaa3a-default-rtdb.firebaseio.com";
  String token = '';
  String userId = '';
  void updateToken(newToken, newUserId) {
    token = newToken;
    userId = newUserId;
    notifyListeners();
  }
  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;
  int get totalProducts => _allProducts.length;

  Future<void> initProducts() async {
    _allProducts = [];
    Uri url = Uri.parse('$baseUrl/products.json?auth=$token&orderBy="userId"&equalTo="$userId"');

    try {
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode <300) {
        if (extractedData != null) {
          extractedData.forEach((id, data) {
            _allProducts.add(
              Product(
                id: id,
                name: data['name'],
                price: data['price'],
                imgUrl: data['imageUrl'],
                createdAt: DateTime.parse(data['createdAt']),
                updatedAt: DateTime.parse(data['updatedAt'])
              )
            );
          });
        }
      } else {
        throw ("${response.statusCode} : ${response.reasonPhrase}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(String name, String price, String imgUrl) async {

    DateTime dateTimeNow = DateTime.now();
    Uri url = Uri.parse("$baseUrl/products.json?auth=$token");

    try {
      var response = await http.post(
        url, body: json.encode({
          'name': name,
          'price': price,
          'imageUrl': imgUrl,
          'createdAt': dateTimeNow.toString(),
          'updatedAt': dateTimeNow.toString(),
          'userId': userId
        })
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _allProducts.add(
          Product(
              id: json.decode(response.body)['name'].toString(),
              name: name,
              price: price,
              imgUrl: imgUrl,
              createdAt: dateTimeNow,
              updatedAt: dateTimeNow
          )
        );
        notifyListeners();
      } else {
        throw ("${response.statusCode} : ${response.reasonPhrase}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Product getProductById(String id) {
    return _allProducts.firstWhere((product) => product.id == id);
  }

  Future<void> editProduct(String id, String name, String price, String imgUrl) async {

    DateTime dateTimeNow = DateTime.now();
    Uri url = Uri.parse("$baseUrl/products/$id.json?auth=$token");

    try {
      final response = await http.patch(
        url, body: json.encode({
          'name': name,
          'price': price,
          'imgUrl': imgUrl
        })
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Product product = getProductById(id);
        product.name = name;
        product.price = price;
        product.imgUrl = imgUrl;
        product.updatedAt = dateTimeNow;
        notifyListeners();

      } else {
        throw ("${response.statusCode} : ${response.reasonPhrase}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) {
    Uri url = Uri.parse("$baseUrl/products/$id.json?auth=$token");

    return http.delete(url).then((response) {
      _allProducts.removeWhere((product) => product.id == id);
      notifyListeners();
    });
  }
}