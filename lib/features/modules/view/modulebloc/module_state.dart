import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ModuleState {}

class ModuleInitial extends ModuleState {}
class ModuleLoading extends ModuleState {}
class ModuleError extends ModuleState {
  final String message;
  ModuleError(this.message);
}

class ModuleLoaded extends ModuleState {
  final List<ModuleModel> modules;
  final String activeFilter; // To highlight the selected chip

  ModuleLoaded(this.modules, {required this.activeFilter});
}

