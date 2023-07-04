import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_filtered.dart';

filtraCatalogo(products, catalogProduct) {
  List<ProductFiltered> items = [];
  items.clear();

  for (var element in products) {
    String productName = element.name;
    List<CatalogProducts> catalog =
        (catalogProduct.where((t) => t.productId == productName)).toList();

    String id;
    double price;
    String sellerName;
    String catalogName;

    if (catalog.isNotEmpty) {
      sellerName = catalog.first.seller;
      catalogName = catalog.first.catalog;
      id = catalog.first.id;
      price = catalog.first.price;

      items.add(
        ProductFiltered(
          id: id,
          code: element.code,
          name: element.name,
          description: element.description,
          category: element.category,
          subCategory: element.subCategory,
          seller: sellerName,
          catalog: catalogName,
          show: element.show,
          unit: element.unit,
          imageUrl: element.imageUrl,
          price: price,
        ),
      );
    }
  }
  return items;
}
