import 'package:event/event.dart';

import '../models/product.dart';

enum ProductEventType { delete, update }

class ProductEvent extends EventArgs {
  ProductEvent(this.product, [this.type = ProductEventType.update]);

  final Product product;
  final ProductEventType type;
}

class FavoriteEvent extends EventArgs {
  FavoriteEvent(this.product, this.favorite);

  final Product product;
  final bool favorite;
}
