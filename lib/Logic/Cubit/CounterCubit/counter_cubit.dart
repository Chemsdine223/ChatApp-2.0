import 'package:bloc/bloc.dart';
import 'package:chat_app/Constants/constants.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  addNotification() {
    emit(state + 1);
    logger.f('Added: $state');
  }

  reset() {
    emit(0);
  }
}
