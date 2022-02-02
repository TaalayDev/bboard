import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ImagePicker {
  static Future<List<Asset>> pickImages(List<Asset> selectedAssets,
      {int maxImages = 10}) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
        enableCamera: true,
        selectedAssets: selectedAssets,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "take photo".tr,
          doneButtonTitle: "ok",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: '#00BB29',
          statusBarColor: '#00BB29',
          actionBarTitle: "Domket",
          selectionLimitReachedText: 'images selection full'.tr,
          textOnNothingSelected: 'no images selected'.tr,
          allViewTitle: "all photos".tr,
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print('pick image error $e');
    }
    return resultList;
  }

  static Future<List<int>> getBytesFromImageAsset(Asset _asset) async {
    final data = await _asset.getByteData();
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
