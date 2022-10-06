import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final DatabaseRepository _databaseRepository;
  InviteBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(InviteState.initial()) {
    on<InviteEvent>((event, emit) async {
      if (event is MemberInviteSent) {
        emit(InviteState.sending());
        // Query User
        // If Users exists ? Add User to Group : Alert message.
        await emit.forEach(
          _databaseRepository.getUserByEmail(event.emailAddress),
          onData: (User? user) {
            if (user != null) {
              _databaseRepository.addMemberToGroup(user.id!, event.group);
              return InviteState.sent();
            } else {
              return InviteState.failed();
            }
          },
          onError: (error, stackTrace) {
            return InviteState.failed();
          },
        );
        await Future.delayed(const Duration(seconds: 3));
        emit(InviteState.initial());
      }
      if (event is ManagerInviteSent) {
        emit(InviteState.sending());
        // Query User
        // If Users exists ? Add User to Group : Alert message.
        await emit.forEach(
          _databaseRepository.getUserByEmail(event.emailAddress),
          onData: (User? user) {
            if (user != null) {
              _databaseRepository.addManagerToGroup(user.id!, event.group);
              return InviteState.sent();
            } else {
              return InviteState.failed();
            }
          },
          onError: (error, stackTrace) {
            return InviteState.failed();
          },
        );
        await Future.delayed(const Duration(seconds: 3));
        emit(InviteState.initial());
      }
      if (event is InviteAccepted) {
        emit(InviteState.accepted());
      }
      if (event is InviteCancelled) {
        emit(InviteState.cancelled());
      }
      if (event is InviteReceived) {
        emit(InviteState.receieved());
      }
      if (event is InviteDenied) {
        emit(InviteState.denied());
      }
      // TODO: implement event handler
    });
  }
}
