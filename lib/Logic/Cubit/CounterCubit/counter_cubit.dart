import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Models/conversation.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitial());

  addNotification(List<Conversation> conversations, int count ){
    
  }
}
