part of 'response_interaction_cubit.dart';

enum Interaction { initial, liked, unliked, replied, failed, submitted, reset }

@immutable
class ResponseInteractionState extends Equatable {
  final Interaction interaction;
  const ResponseInteractionState({required this.interaction});

  factory ResponseInteractionState.initial() {
    return const ResponseInteractionState(interaction: Interaction.initial);
  }
  factory ResponseInteractionState.liked() {
    return const ResponseInteractionState(interaction: Interaction.liked);
  }
  factory ResponseInteractionState.unliked() {
    return const ResponseInteractionState(interaction: Interaction.unliked);
  }
  @override
  List<Object?> get props => [interaction];
}
