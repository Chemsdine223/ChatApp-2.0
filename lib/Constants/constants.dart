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