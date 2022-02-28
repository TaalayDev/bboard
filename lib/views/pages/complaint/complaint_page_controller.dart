import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../models/complaint.dart';
import '../../../models/complaint_type.dart';
import '../../../repositories/settings_repo.dart';
import '../../../tools/locale_storage.dart';

class ComplaintPageController extends GetxController {
  List<ComplaintType> types = [];

  ComplaintType? selectedType;
  String complaintText = '';

  bool isFetching = false;
  bool isSending = false;

  final _settingsRepo = Get.find<SettingsRepo>();

  @override
  void onInit() {
    fetchComplaintTypes();
    super.onInit();
  }

  void changeSelectType(ComplaintType type) {
    selectedType = type;
    update();
  }

  void changeComlaintText(String text) {
    complaintText = text;
    update();
  }

  void fetchComplaintTypes() async {
    isFetching = true;
    update();

    final response = await _settingsRepo.fetchComplaintTypes();
    if (response.status) {
      types = response.data!;
    }

    isFetching = false;
    update();
  }

  Future<void> sendComplaint() async {
    isSending = true;
    update();

    final productId = Get.find<ProductController>().productDetails?.id;
    final response = await _settingsRepo.sendComplaint(Complaint(
      id: 0,
      text: complaintText,
      advertisementId: productId ?? 0,
      userId: LocaleStorage.currentUser?.id ?? 0,
      complaintTypeId: selectedType?.id ?? 0,
    ));

    isSending = false;
    update();

    if (response.status) {
    } else {
      print('send error ${response.errorData}');
      throw Exception();
    }
  }
}
