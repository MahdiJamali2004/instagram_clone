abstract class MyAuthState {}

//initialState
class InitialAuthState extends MyAuthState {}

//AuthenticatedState
class Authenticated extends MyAuthState {
  final String userId;
  Authenticated({required this.userId});
}

//UnAuthenticatedState
class UnAuthenticated extends MyAuthState {}

//ErrorState
class AuthErrorState extends MyAuthState {
  final String error;
  AuthErrorState({required this.error});
}
