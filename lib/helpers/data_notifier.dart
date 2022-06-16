import 'package:flutter/material.dart';

class DataNotifier<T> extends ChangeNotifier {
  DataNotifier(this.data);

  T data;

  DataNotifier<T> operator << (T data) {
    this.data = data;
    notifyListeners();
    return this;
  }
}