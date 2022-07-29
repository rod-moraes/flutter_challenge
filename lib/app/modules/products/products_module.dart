import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/product/datasource/product_datasource.dart';
import '../../domain/product/repository/product_repository.dart';
import 'products_page.dart';
import 'products_store.dart';

class ProductsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => ProductDatasourceWithSdk(databaseService: i())),
    Bind.factory((i) => ProductRepository(datasource: i())),
    Bind.lazySingleton(
        (i) => ProductsStore(productRepository: i(), storageService: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ProductsPage()),
  ];
}
