import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liga_app/features/standings/domain/repositories/standings_repository.dart';
import 'package:liga_app/features/standings/presentation/bloc/standings_event.dart';
import 'package:liga_app/features/standings/presentation/bloc/standings_state.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState>{
  StandingsBloc(this._repository): super(const StandingsInitial()){
    on<StandingsRequested>(_onRequested, transformer: droppable());
    on<CompetitionChanged>(_onCompetitionChanged, transformer: restartable());
  }
  final StandingsRepository _repository;
  String _competition = 'PD';

  Future<void> _onRequested(StandingsRequested event, Emitter<StandingsState> emit) => _load(emit);  

  Future<void> _onCompetitionChanged(CompetitionChanged event, Emitter<StandingsState> emit) async{
    _competition = event.competition;
    await _load(emit);
  }

  Future<void> _load(Emitter<StandingsState> emit) async {
    emit(const StandingsLoading());
    try{
      final standings = await _repository.getStandings(competition: _competition);
      emit(StandingsLoaded(standings));
    }catch(e){
      emit(StandingsError(e.toString()));
    }
  }

}