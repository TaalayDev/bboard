import 'package:get/get.dart';

import '../../../models/notification_model.dart';
import '../../../repositories/settings_repo.dart';

class NotificationsPageController extends GetxController {
  List<NotificationModel> notifications = [];

  bool isFetching = false;
  bool isFetchingMore = false;

  final int limit = 20;
  int offset = 0;
  bool hasReachedMax = false;

  final _settingsRepo = Get.find<SettingsRepo>();

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    if (!isFetching) {
      offset = 0;
      hasReachedMax = false;

      isFetching = true;
      update();

      notifications = await _fetchNotifications(params: {
        'offset': offset,
        'limit': limit,
        'with': 'user',
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      });

      isFetching = false;
      update();
    }
  }

  Future<void> fetchMoreNotifications() async {
    if (!isFetchingMore && !hasReachedMax) {
      offset += limit;

      isFetchingMore = true;
      update();

      final p = await _fetchNotifications(params: {
        'offset': offset,
        'limit': limit,
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      });
      if (p.isNotEmpty) {
        notifications.addAll(p);
      } else {
        hasReachedMax = true;
      }

      isFetchingMore = false;
      update();
    }
  }

  Future<List<NotificationModel>> _fetchNotifications(
      {Map<String, dynamic>? params}) async {
    final appResponse = await _settingsRepo.fetchNotifications(params: params);
    if (appResponse.status) {
      return appResponse.data!;
    }

    return const [];
  }
}
