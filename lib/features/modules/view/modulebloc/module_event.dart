import 'package:flutter/material.dart';

@immutable
sealed class ModuleEvent {}

class FetchModulesEvent extends ModuleEvent {}

class FilterModulesEvent extends ModuleEvent {
  final String filter; // 'All', 'In Progress', 'Completed'
  FilterModulesEvent(this.filter);
}

class SearchModulesEvent extends ModuleEvent {
  final String query;
  SearchModulesEvent(this.query);
}