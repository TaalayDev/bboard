part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.limit = 20,
    this.offset = 1,
  });

  final List<NotificationModel> notifications;
  final bool isLoading;
  final int limit;
  final int offset;
  final bool hasReachedMax;

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? hasReachedMax,
    int? offset,
  }) => NotificationsState(
    notifications: notifications ?? this.notifications,
    isLoading: isLoading ?? this.isLoading,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    offset: offset ?? this.offset,
  );

  @override
  List<Object> get props => [
        notifications,
        isLoading,
        limit,
        offset,
        hasReachedMax,
      ];
}
