import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc() : super(InviteState.initial()) {
    on<InviteEvent>((event, emit) async {
      if (event is InviteSent) {
        emit(InviteState.sending());
        await Future.delayed(const Duration(seconds: 2));
        emit(InviteState.sent());
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
