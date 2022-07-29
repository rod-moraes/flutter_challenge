import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_challenge/app/services/client_service.dart';
import 'package:flutter_challenge/app/services/database_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/products/products_module.dart';
import 'services/storage_service.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => HttpService()),
    Bind.factory((i) => FirebaseFirestore.instance),
    Bind.factory((i) => FirebaseDatabaseService(firestore: i())),
    Bind.factory((i) => FirebaseStorageService(clientService: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    RedirectRoute(Modular.initialRoute, to: '/products/'),
    ModuleRoute('/products', module: ProductsModule()),
    // ModuleRoute('/product/:id', module: ProductsModule()),
  ];
}
