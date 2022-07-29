abstract class ProductsGetState {}

class ProductsGetStateIdle implements ProductsGetState {}

class ProductsGetStateLoading implements ProductsGetState {}

class ProductsGetStateSuccess implements ProductsGetState {
  final String message;
  const ProductsGetStateSuccess({required this.message});
}

class ProductsGetStateFailure implements ProductsGetState {
  final String message;
  const ProductsGetStateFailure({required this.message});
}
