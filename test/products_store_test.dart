import 'package:flutter_challenge/app/domain/product/model/product_model.dart';
import 'package:flutter_challenge/app/domain/product/repository/product_repository.dart';
import 'package:flutter_challenge/app/modules/products/products_store.dart';
import 'package:flutter_challenge/app/modules/products/states/products_get_state.dart';
import 'package:flutter_challenge/app/modules/products/states/products_state.dart';
import 'package:flutter_challenge/app/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mobx/mobx.dart' as mobx;

class ProductRepositoryMock extends mocktail.Mock
    implements IProductRepository {}

class StorageServiceMock extends mocktail.Mock implements StorageService {}

void main() {
  late ProductsStore productsStore;
  late StorageService storageService;
  late IProductRepository productRepository;
  late ProductModel product;
  setUp(() {
    storageService = StorageServiceMock();
    productRepository = ProductRepositoryMock();
    productsStore = ProductsStore(
      productRepository: productRepository,
      storageService: storageService,
    );
    product = ProductModel(
      id: '1',
      title: 'mock',
      type: 'mock',
      description: 'mock',
      filename: 'mock',
      height: 111,
      width: 111,
      price: 10,
      rating: 2,
    );
  });

  test('Testando deletar um produto com success', () async {
    final states = <ProductsState>[];
    mobx.autorun((_) {
      states.add(productsStore.state);
    });
    productsStore.products.add(product);
    int index = 0;
    mocktail
        .when(() =>
            productRepository.deleteProduct(productsStore.products[index].id))
        .thenAnswer((_) => Future.value());
    int lenghtInitial = productsStore.products.length;
    await productsStore.onRemoveProducts(index);

    expect(states[0], isInstanceOf<ProductsStateIdle>());
    expect(states[1], isInstanceOf<ProductsStateLoading>());
    expect(states[2], isInstanceOf<ProductsStateSuccess>());
    expect((productsStore.state as ProductsStateSuccess).message,
        isInstanceOf<String>());
    expect((productsStore.state as ProductsStateSuccess).message,
        "Produto deletado com sucesso!");
    expect(productsStore.products.length, lenghtInitial - 1);
  });

  test('Testando deletar um produto com falha', () async {
    final states = <ProductsState>[];
    mobx.autorun((_) {
      states.add(productsStore.state);
    });
    productsStore.products.add(product);
    int index = 0;
    mocktail
        .when(() =>
            productRepository.deleteProduct(productsStore.products[index].id))
        .thenThrow((_) => Future.value());
    int lenghtInitial = productsStore.products.length;
    await productsStore.onRemoveProducts(index);

    expect(states[0], isInstanceOf<ProductsStateIdle>());
    expect(states[1], isInstanceOf<ProductsStateLoading>());
    expect(states[2], isInstanceOf<ProductsStateFailure>());
    expect((productsStore.state as ProductsStateFailure).message,
        isInstanceOf<String>());
    expect((productsStore.state as ProductsStateFailure).message,
        "Não foi possível deletar o produto!");
    expect(productsStore.products.length, lenghtInitial);
  });

  test('Testando buscar todos os produto com success', () async {
    final states = <ProductsGetState>[];
    mobx.autorun((_) {
      states.add(productsStore.stateGet);
    });
    mocktail
        .when(() => productRepository.getAllProducts())
        .thenAnswer((_) => Future.value([product]));

    await productsStore.getAllProducts();

    expect(states[0], isInstanceOf<ProductsGetStateIdle>());
    expect(states[1], isInstanceOf<ProductsGetStateLoading>());
    expect(states[2], isInstanceOf<ProductsGetStateSuccess>());
    expect((productsStore.stateGet as ProductsGetStateSuccess).message,
        isInstanceOf<String>());
    expect((productsStore.stateGet as ProductsGetStateSuccess).message,
        'Busca realizada com sucesso!!!');
    expect(productsStore.products.length, 1);
    expect(productsStore.products.contains(product), true);
  });

  test('Testando buscar todos os produto com falha', () async {
    final states = <ProductsGetState>[];
    mobx.autorun((_) {
      states.add(productsStore.stateGet);
    });
    mocktail
        .when(() => productRepository.getAllProducts())
        .thenThrow((_) => Future.value());

    await productsStore.getAllProducts();

    expect(states[0], isInstanceOf<ProductsGetStateIdle>());
    expect(states[1], isInstanceOf<ProductsGetStateLoading>());
    expect(states[2], isInstanceOf<ProductsGetStateFailure>());
    expect((productsStore.stateGet as ProductsGetStateFailure).message,
        isInstanceOf<String>());
    expect((productsStore.stateGet as ProductsGetStateFailure).message,
        "Falha ao buscar os produtos!");
  });
}
