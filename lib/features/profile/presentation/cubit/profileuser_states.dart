import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';

abstract class ProfileuserStates {}

//InitialState
class ProfileUserInitialState extends ProfileuserStates {}

//loading
class ProfileUserLoadingState extends ProfileuserStates {}

//loaded
class ProfileLoadedState extends ProfileuserStates {
  final ProfileUser profileuser;

  ProfileLoadedState({required this.profileuser});
}

//error
class ProfileUserErrorState extends ProfileuserStates {
  final String error;

  ProfileUserErrorState({required this.error});
}
