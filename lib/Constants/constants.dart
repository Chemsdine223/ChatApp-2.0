import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Logic/Cubit/ConversationsCubit/conversations_cubit.dart';
import '../Logic/Cubit/OnlineStatusCubit/online_status_cubit.dart';
import '../Logic/Cubit/SocketCubits/socket_connection_cubit.dart';
import '../Logic/Cubit/TypingStatusCubit/typing_status_cubit.dart';
import '../Logic/Network/socket_service.dart';
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

  print('User granted permission: ${settings.authorizationStatus}');
}
