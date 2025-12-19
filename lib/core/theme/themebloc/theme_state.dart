
import 'package:cybercare/core/enum.dart';
class ThemeState{
  final AppThemeMode themeMode;
  const ThemeState(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
