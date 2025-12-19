import 'package:bloc/bloc.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_event.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_state.dart';


class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final ModuleRepository _repository;
  List<ModuleModel> _allModules = []; // Cache all data here

  ModuleBloc(this._repository) : super(ModuleInitial()) {
    on<FetchModulesEvent>(_onFetchModules);
    on<FilterModulesEvent>(_onFilterModules);
    on<SearchModulesEvent>(_onSearchModules);
  }

  Future<void> _onFetchModules(FetchModulesEvent event, Emitter<ModuleState> emit) async {
    emit(ModuleLoading());
    try {
      _allModules = await _repository.fetchModules();
      emit(ModuleLoaded(_allModules, activeFilter: 'All'));
    } catch (e) {
      emit(ModuleError(e.toString()));
    }
  }

  void _onFilterModules(FilterModulesEvent event, Emitter<ModuleState> emit) {
    if (state is! ModuleLoaded) return;

    List<ModuleModel> filtered;

    switch (event.filter) {
      case 'In Progress':
        filtered = _allModules.where((m) => m.percentComplete > 0 && m.percentComplete < 1.0).toList();
        break;
      case 'Completed':
        filtered = _allModules.where((m) => m.percentComplete == 1.0).toList();
        break;
      case 'Not Started':
        filtered = _allModules.where((m) => m.percentComplete == 0).toList();
        break;
      default: // 'All'
        filtered = _allModules;
    }

    emit(ModuleLoaded(filtered, activeFilter: event.filter));
  }

  void _onSearchModules(SearchModulesEvent event, Emitter<ModuleState> emit) {
    if (state is! ModuleLoaded) return;

    final query = event.query.toLowerCase();
    final filtered = _allModules.where((m) => m.title.toLowerCase().contains(query)).toList();

    // Maintain the current filter label visually, but show search results
    emit(ModuleLoaded(filtered, activeFilter: 'All'));
  }
}