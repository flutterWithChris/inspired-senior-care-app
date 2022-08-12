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
        super(MemberLoading()) {
    on<LoadMember>(_onLoadMember);
  }

  void _onLoadMember(LoadMember event, Emitter<MemberState> emit) async {
    await emit.forEach(
      _databaseRepository.getUser(event.userId),
      onData: (User user) {
        print('Member Loaded ${user.name}');
        return MemberLoaded(user: user);
      },
      onError: (error, stackTrace) {
        print('Error Fetching Member ${event.userId}');
        print(error);
        print(stackTrace);
        return MemberFailed();
      },
    );
  }
}
