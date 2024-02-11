// theme_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

// Custom enum to avoid conflict with flutter/material.dart's ThemeMode
enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light);

  void toggleTheme() {
    emit(state == AppTheme.light ? AppTheme.dark : AppTheme.light);
  }
}
