part of 'comments_cubit.dart';

class CommentsState extends Equatable {
  const CommentsState({
    required this.productId,
    this.comments = const [],
    this.isLoading = false,
    this.replyingTo,
  });

  final int productId;
  final List<Comment> comments;
  final bool isLoading;
  final Comment? replyingTo;

  CommentsState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    Comment? replyingTo,
  }) =>
      CommentsState(
        productId: productId,
        comments: comments ?? this.comments,
        isLoading: isLoading ?? this.isLoading,
        replyingTo: replyingTo,
      );

  @override
  List<Object?> get props => [comments, isLoading, replyingTo, productId];
}
