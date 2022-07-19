part of 'share_bloc.dart';

@immutable
abstract class ShareEvent extends Equatable {}

class SubmitPressed extends ShareEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ResponseSubmitted extends ShareEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
