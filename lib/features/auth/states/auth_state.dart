import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boilerplate_template/shared/user/models/user_model.dart';

part 'auth_state.freezed.dart';

// État d'authentification unifié avec UserModel complet
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.authenticated(UserModel user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.codeSent(String verificationId) = AuthCodeSent;
}
