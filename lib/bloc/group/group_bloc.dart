import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final DatabaseRepository _databaseRepository;
  GroupBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(GroupInitial()) {
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);
  }

  void _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    emit(GroupSubmitting());
    await Future.delayed(const Duration(seconds: 2));
    _databaseRepository.addNewGroup(event.group, event.manager);
    emit(GroupSubmitted());
    emit(GroupCreated(group: event.group));
    await Future.delayed(const Duration(seconds: 2));
    emit(GroupInitial());
  }

  void _onUpdateGroup(UpdateGroup event, Emitter<GroupState> emit) {
    _databaseRepository.updateGroup(event.group);
  }
}
