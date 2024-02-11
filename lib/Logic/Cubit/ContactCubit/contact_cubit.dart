import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:chat_app/Logic/Network/network_services.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial()) {
    getContacts();
  }
  Future<void> getContacts() async {
    try {
      final response = await NetworkServices().getContacts();
      emit(ContactLoaded(contacts: response));
    } catch (e) {
      emit(ContactError(errorMsg: e.toString()));
    }
  }

  // void test() {
  //   if (state is ConversationsLoaded) {
  //     log(conversationsCubit.state.toString());
  //   }
  // }
}
