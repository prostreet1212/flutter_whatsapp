import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/contact_entity.dart';
import '../../../domain/use_cases/user/get_device_number_usecase.dart';

part 'get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {
  final GetDeviceNumberUseCase getDeviceNumberUseCase;
  GetDeviceNumberCubit({required this.getDeviceNumberUseCase})
      : super(GetDeviceNumberInitial());

  Future<void> getDeviceNumber() async {
    try{
      List<ContactEntity> contactNumbers=await getDeviceNumberUseCase.call();
      emit(GetDeviceNumberLoaded(contacts: contactNumbers));
    }catch(_){
      emit(GetDeviceNumberFailure());
    }
  }

}
