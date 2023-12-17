import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homework/main.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:flutter_homework/ui/provider/login/login_model.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


  LoginBloc() : super(LoginForm()) {
    GetIt.I<EmailPass>().setEmail(null);
      GetIt.I<EmailPass>().setPass(null);
    on<LoginAutoLoginEvent>((event, emit) async {
      String? token = GetIt.I<SharedPreferences>().getString('token');
      if(token != null){
        GetIt.I<MyToken>().setToken(token);
        emit(LoginSuccess());
      }
    });

    on<LoginSubmitEvent>((event, emit) async {
      if(state is! LoginLoading){
        emit(LoginLoading());
        GetIt.I<EmailPass>().setEmail(null);
        GetIt.I<EmailPass>().setPass(null);
        try {
          String? emailErrorText = _isValidEmail(event.props[0].toString());
          String? passwordErrorText = _isValidPassword(event.props[1].toString());
        if (emailErrorText == null && passwordErrorText == null) {
          String token = await login(event.email, event.password);
          if (event.props[2] == true) {
              await saveTokenToSharedPreferences(token); 
          }
          GetIt.I<MyToken>().setToken(token);
          emit(LoginSuccess());
          emit(LoginForm());
        }
        else{
          if (emailErrorText != null){
            GetIt.I<EmailPass>().setEmail(emailErrorText);
          }
          if (passwordErrorText != null){
            GetIt.I<EmailPass>().setPass(passwordErrorText);
          }
          emit(LoginForm());
        }
          
        }
        on LoginException catch (e) {        
          emit(LoginError(e.message));
          emit(LoginForm());
      }
  }
  });
  }
  

  Future<String> login(String email, String password) async {
    
    try {
      var response = await GetIt.I<Dio>().post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data['token'] as String;
    } catch (e) {
      if (e is DioException) {
        throw LoginException(e.response!.data['message'] as String);
      } else {
        throw LoginException(e.toString());
      }
    }
  }


    Future<void> saveTokenToSharedPreferences(String token) async {
      await GetIt.I<SharedPreferences>().setString('token', token);
    }

String? _isValidEmail(String email) {
  if (email.isEmpty) {
    return null;
  } else if (!email.contains('@')) {
    return 'Incorrect email';
  } else {
    return null;
  }
}

String? _isValidPassword(String password) {
  if (password.isEmpty) {
    return null;
  } else if (password.length < 6) {
    return 'Incorrect password';
  } else {
    return null;
  }
}

}

class MyToken {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }
}

class EmailPass {
  String? _email;
  String? _pass;

  String? get email => _email;
  String? get pass => _pass;

  void setEmail(String? email) {
    _email = email;
  }
  void setPass(String? pass) {
    _pass = pass;
  }
}