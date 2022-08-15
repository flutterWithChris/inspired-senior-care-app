part of 'response_bloc.dart';

@immutable
abstract class ResponseState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResponseInitial extends ResponseState {}

class ResponseLoading extends ResponseState {}

class ResponseLoaded extends ResponseState {
  final List<Response>? responses;
  ResponseLoaded({
    this.responses,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [responses];
}

class ResponseFailed extends ResponseState {}
