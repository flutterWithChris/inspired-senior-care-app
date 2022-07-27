import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<CompletedPage>((event, emit) {
      emit(PageComplete());
      add(NextPage());
    });
    on<NextPage>(((event, emit) => emit(OnboardingInitial())));
  }
}
