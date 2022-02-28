import 'package:bboard/resources/theme.dart';
import 'package:bboard/views/pages/notifications/notifications_page_controller.dart';
import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../widgets/loading_more_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: SizedBox(),
        title: 'Уведомления',
      ),
      body: GetBuilder<NotificationsPageController>(
        init: NotificationsPageController(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchNotifications();
            },
            child: Builder(builder: (context) {
              if (controller.isFetching) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Feather.bell_off),
                      const SizedBox(height: 20),
                      Text(
                        'У вас нет уведомлений',
                        style: TextStyle(
                          fontSize: 16,
                          color: context.theme.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    controller.fetchMoreNotifications();
                  }

                  return false;
                },
                child: CustomScrollView(
                  controller: ScrollController(),
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(),
                            );
                          },
                          childCount: controller.notifications.length,
                        ),
                      ),
                    ),
                    controller.isFetchingMore
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: const [
                                SizedBox(height: 20),
                                LoadingMoreWidget(),
                              ],
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox()),
                    const SliverToBoxAdapter(child: SizedBox(height: 50)),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
