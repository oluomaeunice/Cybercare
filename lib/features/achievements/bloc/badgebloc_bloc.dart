import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cybercare/features/modules/data/models/module_models.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:meta/meta.dart';

// EVENTS
@immutable
sealed class BadgeEvent {}

class FetchBadgeData extends BadgeEvent {} // Loads both earned and locked

class LoadBadgeCreationData extends BadgeEvent {} // Loads modules for dropdown

class CreateBadgeEvent extends BadgeEvent {
  final String name;
  final String description;
  final String moduleId;
  final File image;

  CreateBadgeEvent({
    required this.name,
    required this.description,
    required this.moduleId,
    required this.image,
  });
}

// STATES
@immutable
sealed class BadgeState {}
class BadgeInitial extends BadgeState {}
class BadgeLoading extends BadgeState {}
class BadgeError extends BadgeState {
  final String message;
  BadgeError(this.message);
}

class BadgeDataLoaded extends BadgeState {
  final List<BadgeModel> earnedBadges;
  final List<BadgeModel> lockedBadges;
  BadgeDataLoaded({required this.earnedBadges, required this.lockedBadges});
}

class BadgeCreationReady extends BadgeState {
  final List<ModuleModel> availableModules;
  BadgeCreationReady(this.availableModules);
}

class BadgeCreatedSuccess extends BadgeState {}

// BLOC
class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final ModuleRepository _repository;

  BadgeBloc(this._repository) : super(BadgeInitial()) {
    on<FetchBadgeData>(_onFetchData);
    on<LoadBadgeCreationData>(_onLoadCreationData);
    on<CreateBadgeEvent>(_onCreateBadge);
  }

  Future<void> _onFetchData(FetchBadgeData event, Emitter<BadgeState> emit) async {
    emit(BadgeLoading());
    try {
      final allBadges = await _repository.getAllBadges();
      final earnedBadges = await _repository.getUserBadges();

      // Determine locked badges by subtracting earned from all
      // Use names or IDs to compare
      final earnedNames = earnedBadges.map((e) => e.name).toSet();
      final lockedBadges = allBadges.where((b) => !earnedNames.contains(b.name)).toList();

      emit(BadgeDataLoaded(earnedBadges: earnedBadges, lockedBadges: lockedBadges));
    } catch (e) {
      emit(BadgeError(e.toString()));
    }
  }

  Future<void> _onLoadCreationData(LoadBadgeCreationData event, Emitter<BadgeState> emit) async {
    emit(BadgeLoading());
    try {
      final modules = await _repository.getModulesWithoutBadges();
      emit(BadgeCreationReady(modules));
    } catch (e) {
      emit(BadgeError(e.toString()));
    }
  }

  Future<void> _onCreateBadge(CreateBadgeEvent event, Emitter<BadgeState> emit) async {
    emit(BadgeLoading());
    try {
      await _repository.createBadge(
        name: event.name,
        description: event.description,
        moduleId: event.moduleId,
        imageFile: event.image,
      );
      emit(BadgeCreatedSuccess());
    } catch (e) {
      emit(BadgeError(e.toString()));
    }
  }
}