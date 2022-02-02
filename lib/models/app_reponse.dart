class AppResponse<T> {
  late bool status;
  String? message;
  T? data;
  dynamic errorData;

  AppResponse({
    this.status = false,
    this.message,
    this.data,
    this.errorData,
  });

  AppResponse.fromMap(map) {
    status = map['success'] ?? false;
    message = map['message'];
  }
}
