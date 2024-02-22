// theme_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom enum to avoid conflict with flutter/material.dart's ThemeMode
enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light) {
    getTheme();
  }

  void toggleTheme() {
  state == AppTheme.light ? setTheme(true) : setTheme(false);
  emit(state == AppTheme.light ? AppTheme.dark : AppTheme.light);
}


  void setTheme(bool themeSetter) async {
    // print('set');
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', themeSetter);
  }

  void getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.get('theme');
    // print('theme: $theme');
    if (theme == true) {
      emit(AppTheme.dark);
    } else {
      emit(AppTheme.light);
    }
  }
}
