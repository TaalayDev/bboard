import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../cubit/notifications_cubit.dart';
import '../../../res/globals.dart';
import '../../../res/theme.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_more_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationCubit = NotificationsCubit(settingsRepo: getIt.get());

    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: SizedBox(),
        title: 'Уведомления',
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        bloc: notificationCubit..fetchNotifications(),
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              notificationCubit
                ..clearOffset()
                ..fetchNotifications();
            },
            child: Builder(builder: (context) {
              if (state.isLoading && state.offset == 1) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.notifications.isEmpty) {
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
                    notificationCubit.fetchNotifications();
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
                            final notification = state.notifications[index];
                            return InkWell(
                              onTap: () {},
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                leading: notification.image == null
                                    ? CircleAvatar(
                                        backgroundColor:
                                            context.theme.grey.withOpacity(0.5),
                                        child: const Icon(
                                          Feather.bell,
                                          color: Colors.white,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: AppNetworkImage(
                                          imageUrl: notification.image!,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                title: Text(
                                  notification.title,
                                ),
                                subtitle: Text(
                                  notification.body,
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 3,
                                ),
                              ),
                            );
                          },
                          childCount: state.notifications.length,
                        ),
                      ),
                    ),
                    state.isLoading
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
