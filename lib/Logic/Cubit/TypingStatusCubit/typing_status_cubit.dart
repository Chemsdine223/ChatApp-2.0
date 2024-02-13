import 'package:bloc/bloc.dart';

part 'typing_status_state.dart';

class TypingStatusCubit extends Cubit<TypingStatusState> {
  TypingStatusCubit() : super(const TypingStatusState({}));

  void handleTypingStatus(String conversationId, bool isTyping) {
    final updatedMap = Map<String, String>.from(state.typingStatusMap);

    if (isTyping) {
      updatedMap[conversationId] = conversationId;
    } else {
      updatedMap.remove(conversationId);
    }

    emit(TypingStatusState(updatedMap));
  }
}
