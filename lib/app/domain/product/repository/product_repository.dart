import '../datasource/product_datasource.dart';
import '../model/product_model.dart';

abstract class IProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> deleteProduct(String id);
  Future<void> editProduct(ProductModel productModel);
}

class ProductRepository implements IProductRepository {
  final IProductDatasource datasource;
  const ProductRepository({required this.datasource});
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      String response = await datasource.getAllProducts();
      List<ProductModel> products = ProductModel.listFromJson(response);
      return products;
    } catch (e) {
      throw Exception("Erro: $e");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await datasource.deleteProduct(id);
    } catch (e) {
      throw Exception("Erro: $e");
    }
  }

  @override
  Future<void> editProduct(ProductModel productModel) async {
    try {
      await datasource.editProduct(productModel);
    } catch (e) {
      throw Exception("Erro: $e");
    }
  }
}
