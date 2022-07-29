import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../domain/product/model/product_model.dart';
import '../../domain/product/repository/product_repository.dart';
import '../../services/storage_service.dart';
import 'states/products_get_state.dart';
import 'states/products_state.dart';

part 'products_store.g.dart';

class ProductsStore = ProductsStoreBase with _$ProductsStore;

abstract class ProductsStoreBase with Store {
  final IProductRepository productRepository;
  final StorageService storageService;

  ProductsStoreBase(
      {required this.productRepository, required this.storageService});

  @observable
  ProductsGetState stateGet = ProductsGetStateIdle();

  @observable
  ProductsState state = ProductsStateIdle();

  @observable
  ObservableList<ProductModel> products = ObservableList<ProductModel>.of([]);

  @action
  Future<void> getAllProducts() async {
    stateGet = ProductsGetStateLoading();
    try {
      await Future.delayed(const Duration(seconds: 0));
      List<ProductModel> products = await productRepository.getAllProducts();
      this.products.removeWhere((element) => true);
      this.products.addAll(products);
      stateGet = const ProductsGetStateSuccess(
          message: 'Busca realizada com sucesso!!!');
    } catch (e) {
      stateGet = const ProductsGetStateFailure(
          message: "Falha ao buscar os produtos!");
    }
  }

  Future<File> getCachedImageFile(final String imageId) {
    return storageService.getCachedImageFile(imageId);
  }

  @action
  Future<bool> onRemoveProducts(int index) async {
    try {
      state = ProductsStateLoading();
      await productRepository.deleteProduct(products[index].id);
      products.removeAt(index);
      state =
          const ProductsStateSuccess(message: "Produto deletado com sucesso!");
      return true;
    } catch (e) {
      state = const ProductsStateFailure(
          message: "Não foi possível deletar o produto!");
      return false;
    }
  }

  @action
  Future<bool> onEditProduct(ProductModel product, int index) async {
    try {
      state = ProductsStateLoading();
      await productRepository.editProduct(product);
      products[index] = product.copyWith();
      state =
          const ProductsStateSuccess(message: "Produto editado com sucesso!");
      return true;
    } catch (e) {
      state = const ProductsStateFailure(
          message: "Não foi possível editar o produto!");
      return false;
    }
  }
}
