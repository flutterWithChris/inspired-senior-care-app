part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, started, complete, failed }

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboarsingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final User user;

  const OnboardingLoaded({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class PageComplete extends OnboardingState {}

class PageLoaded extends OnboardingState {}
