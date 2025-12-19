import 'package:bloc/bloc.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:meta/meta.dart';

// EVENTS
@immutable
sealed class ModuleDetailEvent {}

class LoadModuleDetails extends ModuleDetailEvent {
  final String moduleId;
  LoadModuleDetails(this.moduleId);
}

class MarkTopicCompleted extends ModuleDetailEvent {
  final String moduleId;
  final String topicId;
  MarkTopicCompleted(this.moduleId, this.topicId);
}

// STATES
@immutable
sealed class ModuleDetailState {}
class ModuleDetailInitial extends ModuleDetailState {}
class ModuleDetailLoading extends ModuleDetailState {}
class ModuleDetailLoaded extends ModuleDetailState {
  final List<TopicModel> topics;
  final double progress;
  final BadgeModel? newlyEarnedBadge; // <--- Add this nullable field

  ModuleDetailLoaded(
      this.topics,
      this.progress,
      {this.newlyEarnedBadge} // Optional parameter
      );
}

// BLOC
class ModuleDetailBloc extends Bloc<ModuleDetailEvent, ModuleDetailState> {
  final ModuleRepository _repository;

  ModuleDetailBloc(this._repository) : super(ModuleDetailInitial()) {
    on<LoadModuleDetails>(_onLoadDetails);
    on<MarkTopicCompleted>(_onMarkCompleted);
  }

  Future<void> _onLoadDetails(LoadModuleDetails event, Emitter<ModuleDetailState> emit) async {
    emit(ModuleDetailLoading());
    try {
      final topics = await _repository.getTopicsForModule(event.moduleId);
      final progress = _calculateProgress(topics);
      emit(ModuleDetailLoaded(topics, progress));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onMarkCompleted(MarkTopicCompleted event, Emitter<ModuleDetailState> emit) async {
    if (state is ModuleDetailLoaded) {
      final currentState = state as ModuleDetailLoaded;

      // 1. Optimistic UI Update (Mark topic as done)
      final updatedTopics = currentState.topics.map((t) {
        return t.id == event.topicId ? t.copyWith(isCompleted: true) : t;
      }).toList();

      final newProgress = _calculateProgress(updatedTopics);

      // Emit the updated list first (progress bar moves)
      emit(ModuleDetailLoaded(updatedTopics, newProgress));

      // 2. Sync with Database
      await _repository.markTopicComplete(event.moduleId, event.topicId);

      // 3. CHECK FOR BADGE (If progress hit 100%)
      if (newProgress == 1.0) {
        // A. Save to DB
        await _repository.awardBadge(event.moduleId);

        // B. Fetch Badge Details to show user
        final badge = await _repository.getBadgeForModule(event.moduleId);

        if (badge != null) {
          // Emit state WITH the badge to trigger listener in UI
          emit(ModuleDetailLoaded(updatedTopics, newProgress, newlyEarnedBadge: badge));
        }
      }
    }
  }

  double _calculateProgress(List<TopicModel> topics) {
    if (topics.isEmpty) return 0;
    final completed = topics.where((t) => t.isCompleted).length;
    return completed / topics.length;
  }
}