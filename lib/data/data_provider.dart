import 'package:flutter/material.dart';

import 'models/category.dart';
import 'models/filter.dart';
import 'models/product.dart';

class DataProvider {
  ValueNotifier<Product?> product = ValueNotifier(null);
  ValueNotifier<Category?> category = ValueNotifier(null);
  ValueNotifier<Filter?> filter = ValueNotifier(null);
}
