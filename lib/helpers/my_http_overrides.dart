import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate certificate, String host, int port) {
        return ['api.domket.kg'].contains(host);
      };
  }
}
