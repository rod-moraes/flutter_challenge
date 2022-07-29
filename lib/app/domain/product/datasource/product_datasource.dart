import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../services/database_service.dart';
import '../model/product_model.dart';

abstract class IProductDatasource {
  Future<String> getAllProducts();
  Future<void> deleteProduct(String id);
  Future<void> editProduct(ProductModel product);
}

class ProductDatasourceJson implements IProductDatasource {
  @override
  Future<String> getAllProducts() async {
    const file = "assets/database/products.json";
    final data = await rootBundle.load(file);
    final buffer = data.buffer;
    final list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final products = utf8.decode(list);
    return products;
  }

  @override
  Future<void> deleteProduct(String id) async {}

  @override
  Future<void> editProduct(ProductModel product) async {}
}

class ProductDatasourceWithSdk implements IProductDatasource {
  final DatabaseService databaseService;

  const ProductDatasourceWithSdk({required this.databaseService});
  @override
  Future<String> getAllProducts() async {
    try {
      return json.encode(await databaseService.getAllFromCollection('products',
          orderBy: 'filename'));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await databaseService.deleteWithIdFromCollection('products', id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editProduct(ProductModel product) async {
    try {
      await databaseService.editWithIdFromCollection(
          'products', product.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
