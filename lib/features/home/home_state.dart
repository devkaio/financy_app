abstract class HomeState {}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateSuccess extends HomeState {}

class HomeStateError extends HomeState {
  HomeStateError({required this.message});

  final String message;
}
