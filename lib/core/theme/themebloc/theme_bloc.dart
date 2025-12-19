
import 'package:cybercare/core/enum.dart';
import 'package:cybercare/core/theme/themebloc/theme_event.dart';
import 'package:cybercare/core/theme/themebloc/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _key = 'app_theme_mode';

  ThemeBloc() : super(const ThemeState(AppThemeMode.system)) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_key);

    final themeMode = AppThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
      orElse: () => AppThemeMode.system,
    );

    emit(ThemeState(themeMode));
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.themeMode.name);
    emit(ThemeState(event.themeMode));
  }
}

