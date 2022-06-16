import 'package:event/event.dart';

import '../models/product.dart';
import 'product_events.dart';

final productEvents = Event<ProductEvent>();
final favoriteEvents = Event<FavoriteEvent>();

void sendAddedToFavoriteEvent(Product product) {
  favoriteEvents.broadcast(FavoriteEvent(product, true));
  sendProductUpdatedEvent(product);
}

void sendRemovedFromFavoriteEvent(Product product) {
  favoriteEvents.broadcast(FavoriteEvent(product, false));
  sendProductUpdatedEvent(product);
}

void sendProductDeletedEvent(Product product) {
  productEvents.broadcast(ProductEvent(product, ProductEventType.delete));
}

void sendProductUpdatedEvent(Product product) {
  productEvents.broadcast(ProductEvent(product));
}
