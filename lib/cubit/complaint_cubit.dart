import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/complaint.dart';
import '../data/models/complaint_type.dart';
import '../data/repositories/settings_repo.dart';
import '../data/storage.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  ComplaintCubit(int productId, {required ISettingsRepo settingsRepo})
      : _settingsRepo = settingsRepo,
        super(ComplaintState(productId: productId));

  final ISettingsRepo _settingsRepo;

  void setComplaintType(ComplaintType type) {
    emit(state.copyWith(selectedType: type));
  }

  void setText(String text) {
    emit(state.copyWith(text: text));
  }

  void fetchComplaintTypes() async {
    emit(state.copyWith(isLoading: true));
    final response = await _settingsRepo.fetchComplaintTypes();
    emit(state.copyWith(isLoading: false, types: response.result));
  }

  void sendComplaint() async {
    emit(state.copyWith(isLoading: true));
    final response = await _settingsRepo.sendComplaint(Complaint(
      id: 0,
      text: state.text ?? '',
      advertisementId: state.productId,
      userId: LocaleStorage.currentUser?.id ?? 0,
      complaintTypeId: state.selectedType?.id ?? 0,
    ));
    emit(state.copyWith(
      isLoading: false,
      status: response.status ? ComplaintStatus.success : ComplaintStatus.error,
      error: response.errorData,
    ));
  }
}
