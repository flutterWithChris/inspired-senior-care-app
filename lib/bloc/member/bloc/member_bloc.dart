import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final DatabaseRepository _databaseRepository;
  MemberBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(MemberInitial()) {
    on<LoadMember>(_onLoadMember);
    on<ResetMember>(
      (event, emit) => emit(MemberInitial()),
    );
  }

  void _onLoadMember(LoadMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    User member = User.empty;
    _databaseRepository.getUser(event.userId).listen((user) {
      member = user;
    });
    await Future.delayed(const Duration(seconds: 1));
    emit(MemberLoaded(user: member));
  }
}
