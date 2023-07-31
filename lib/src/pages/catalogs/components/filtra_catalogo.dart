import 'package:rm/src/models/catalog_products_model.dart';
import 'package:rm/src/models/product_filtered.dart';

filtraCatalogo(products, catalogProduct) {
  List<ProductFiltered> items = [];
  items.clear();

  for (var element in products) {
    String productName = element.name;
    List<CatalogProducts> catalog =
        (catalogProduct.where((t) => t.productId == productName)).toList();

    // CatalogProducts? get catalog =>
    //   catalogProduct.firstWhereOrNull((element) => element.productId == productName);

    String id;
    double price;
    int pageNumber;
    int itemNumber;
    String sellerName;
    String catalogName;

    if (catalog.isNotEmpty) {
      sellerName = catalog.first.seller;
      catalogName = catalog.first.catalog;
      id = catalog.first.id;
      price = catalog.first.price;
      pageNumber = catalog.first.pageNumber;
      itemNumber = catalog.first.itemNumber;

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
          pageNumber: pageNumber,
          itemNumber: itemNumber,
          price: price,
        ),
      );
    }
  }
  return items;
}
