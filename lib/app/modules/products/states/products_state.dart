abstract class ProductsState {}

class ProductsStateIdle implements ProductsState {}

class ProductsStateLoading implements ProductsState {}

class ProductsStateSuccess implements ProductsState {
  final String message;
  const ProductsStateSuccess({required this.message});
}

class ProductsStateFailure implements ProductsState {
  final String message;
  const ProductsStateFailure({required this.message});
}
