class AppResponse<T> {
  String? message;
  T? result;
  dynamic errorData;
  int? statusCode;

  bool get status => statusCode == 200 || statusCode == 201;

  AppResponse({
    this.statusCode,
    this.message,
    this.result,
    this.errorData,
  });

  AppResponse.fromMap(map) {}
}
