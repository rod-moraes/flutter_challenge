// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductsStore on ProductsStoreBase, Store {
  late final _$stateGetAtom =
      Atom(name: 'ProductsStoreBase.stateGet', context: context);

  @override
  ProductsGetState get stateGet {
    _$stateGetAtom.reportRead();
    return super.stateGet;
  }

  @override
  set stateGet(ProductsGetState value) {
    _$stateGetAtom.reportWrite(value, super.stateGet, () {
      super.stateGet = value;
    });
  }

  late final _$stateAtom =
      Atom(name: 'ProductsStoreBase.state', context: context);

  @override
  ProductsState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ProductsState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$productsAtom =
      Atom(name: 'ProductsStoreBase.products', context: context);

  @override
  ObservableList<ProductModel> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<ProductModel> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$getAllProductsAsyncAction =
      AsyncAction('ProductsStoreBase.getAllProducts', context: context);

  @override
  Future<void> getAllProducts() {
    return _$getAllProductsAsyncAction.run(() => super.getAllProducts());
  }

  @override
  String toString() {
    return '''
stateGet: ${stateGet},
state: ${state},
products: ${products}
    ''';
  }
}
