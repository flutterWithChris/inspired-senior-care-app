import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<GroupEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is CreateGroup) {
        emit(GroupSubmitting());
        await Future.delayed(const Duration(seconds: 2));
        emit(GroupSubmitted());
        emit(GroupCreated());
        await Future.delayed(const Duration(seconds: 2));
        emit(GroupInitial());
      }
    });
  }
}
