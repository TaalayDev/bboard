import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../data/constants.dart';
import '../data/models/category.dart';
import '../res/theme.dart';

int? parseInt(val, {int? defVal = 0}) {
  try {
    return val is int ? val : int.parse(val);
  } catch (e) {
    return defVal;
  }
}

double? parseDouble(val, {double? defVal = 0}) {
  try {
    return val is double ? val : double.parse(val);
  } catch (e) {
    return defVal;
  }
}

String numberWithSpaces(int number, {int spaceEvery = 3}) {
  String numStr = number.toString();
  String result = '';

  int spaceCount = spaceEvery;
  for (int index = numStr.length - 1; index >= 0; index--) {
    if (spaceCount == 0) {
      result += ' ';
      spaceCount = spaceEvery;
    }
    result += numStr[index];
    spaceCount--;
  }

  return result.split('').reversed.join();
}

String replaceAll(
  String str,
  List<String> replacementList,
  String replaceWith,
) {
  for (var s in replacementList) {
    str = str.replaceAll(s, replaceWith);
  }

  return str;
}

String doubleDigits(val) {
  if (val < 10) return '0$val';
  return '$val';
}

Color? colorFromHex(String s, {Color? defColor = Colors.grey}) {
  try {
    return Color(int.parse(s.replaceAll('#', '0xFF')));
  } catch (e) {
    return defColor;
  }
}

String parseError(error, {String Function(dynamic key)? getKey}) {
  var message = error.toString();
  if (error is List) {
    message = error.map((e) {
      return parseError(e, getKey: getKey);
    }).join('\n');
  } else if (error is Map) {
    message = error.keys.map((key) {
      return (getKey?.call(key) ?? '') + parseError(error[key]);
    }).join('\n');
  }

  return message;
}

unfocus() {
  return FocusManager.instance.primaryFocus?.unfocus();
}

Future<DateTime?> selectDate({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  bool Function(DateTime dt)? selectableDayPredicate,
}) =>
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: selectableDayPredicate,
      helpText: 'Выберите дату',
      cancelText: 'Отмена',
      confirmText: 'Выбрать',
    );

String? fixedUrl(String? url) {
  if (url == null) return null;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;

  return Constants.baseUrl + url;
}

/// Creates an image from the given widget by first spinning up a element and render tree,
/// then waiting for the given [wait] amount of time and then creating an image via a [RepaintBoundary].
///
/// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
Future<Uint8List?> createImageFromWidget(Widget widget,
    {Duration? wait, Size? logicalSize, Size? imageSize}) async {
  final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

  logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
  imageSize ??= ui.window.physicalSize;

  // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

  final RenderView renderView = RenderView(
    window: ui.window,
    child: RenderPositionedBox(
        alignment: Alignment.center, child: repaintBoundary),
    configuration: ViewConfiguration(
      size: logicalSize,
      devicePixelRatio: 1.0,
    ),
  );

  final PipelineOwner pipelineOwner = PipelineOwner();
  final BuildOwner buildOwner = BuildOwner();

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final RenderObjectToWidgetElement<RenderBox> rootElement =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  if (wait != null) {
    await Future.delayed(wait);
  }

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final ui.Image image = await repaintBoundary.toImage(
      pixelRatio: imageSize.width / logicalSize.width);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData?.buffer.asUint8List();
}

List<Icon> getStarsList(double rate, {double size = 18}) {
  var list = <Icon>[];
  list = List.generate(rate.floor(), (index) {
    return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
  });
  if (rate - rate.floor() > 0) {
    list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
  }
  list.addAll(
      List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
    return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
  }));

  return list;
}

String getParentsTree(Category category) {
  return (category.parent != null
          ? getParentsTree(category.parent!) + ' > '
          : '') +
      category.name;
}

String convertUrlToId(String? url, {bool trimWhitespaces = true}) {
  assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
  if (!url!.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1) ?? '';
  }

  return url;
}

OverlayEntry showLoader(BuildContext context) {
  OverlayEntry loader = OverlayEntry(builder: (context) {
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: context.theme.background,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 25),
              Text(
                'Загрузка...',
                style: TextStyle(color: context.theme.mainTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  });
  Overlay.of(context)?.insert(loader);

  return loader;
}

Future<File?> fileFromUrl(String url) async {
  try {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final path = (await getTemporaryDirectory()).path;
    final file =
        File(path + '/' + DateTime.now().millisecondsSinceEpoch.toString());
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  } on DioError {
    return null;
  }
}
