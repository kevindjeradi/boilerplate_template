import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

// État d'authentification uniquement
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(String userId) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.codeSent(String verificationId) = AuthCodeSent;
}
