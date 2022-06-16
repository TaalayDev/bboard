part of 'complaint_cubit.dart';

enum ComplaintStatus { none, success, error }

class ComplaintState extends Equatable {
  const ComplaintState({
    this.types = const [],
    this.isLoading = false,
    this.selectedType,
    this.text,
    required this.productId,
    this.status = ComplaintStatus.none,
    this.error,
  });

  final List<ComplaintType> types;
  final ComplaintType? selectedType;
  final String? text;
  final bool isLoading;
  final int productId;
  final ComplaintStatus status;
  final String? error;

  ComplaintState copyWith({
    List<ComplaintType>? types,
    ComplaintType? selectedType,
    String? text,
    bool? isLoading,
    ComplaintStatus? status,
    String? error,
  }) =>
      ComplaintState(
        types: types ?? this.types,
        selectedType: selectedType ?? this.selectedType,
        text: text ?? this.text,
        isLoading: isLoading ?? this.isLoading,
        productId: productId,
        status: status ?? this.status,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        productId,
        types,
        isLoading,
        selectedType,
        text,
        status,
        error,
      ];
}
