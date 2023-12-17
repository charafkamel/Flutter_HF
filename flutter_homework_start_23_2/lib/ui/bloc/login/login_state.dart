part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {

  LoginState();
}

class LoginForm extends LoginState {
  
  LoginForm();

  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
