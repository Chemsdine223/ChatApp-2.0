import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import '../Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import '../Logic/Cubit/SocketCubits/socket_connection_cubit.dart';
import '../Logic/Cubit/TypingStatusCubit/typing_status_cubit.dart';
import '../Network/socket_service.dart';
import '../Theme/theme_cubit.dart';

final supabase = Supabase.instance.client;
var logger = Logger(
    printer: PrettyPrinter(
  colors: true,
));

final conversationsCubit = ConversationsCubit();
final connectionCubit = SocketConnectionCubit();
final onlineStatusCubit = OnlineStatusCubit();
final typingStatusCubit = TypingStatusCubit();
final themeCubit = ThemeCubit();
final socketService = SocketService();

Future<void> initializeServices() async {}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  logger.d('User granted permission: ${settings.authorizationStatus}');
}

late bool hasConnection;

// ENDPOINTS //

// static const baseUrl = 'http://127.0.0.1:5000';
// ! Phone IP adresse
const baseUrl = 'http://172.20.10.5:5000';
// ! Mauritel
// const baseUrl = 'http://192.168.100.30:5000';
// ! Sahel
// const baseUrl = 'http://192.168.0.114:5000';
// const baseUrl = 'http://192.168.1.212:5000';
const loginUrl = '$baseUrl/api/login';
const registerUrl = '$baseUrl/api/register';
const getConvos = '$baseUrl/api/getConvos';
const getBlogs = '$baseUrl/api/getBlogs';
const createConvo = '$baseUrl/api/createConversation';
const deleteAccount = '$baseUrl/api/deleteAccount';
const editPhoneNumber = '$baseUrl/api/editPhone';
const deleteConvo = '$baseUrl/api/deleteConversation';
const seenMessage = '$baseUrl/api/seen';
const editProfilePhoto = '$baseUrl/api/editPhoto';
