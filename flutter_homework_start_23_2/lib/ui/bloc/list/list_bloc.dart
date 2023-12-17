import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homework/main.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:flutter_homework/ui/provider/list/list_model.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_event.dart';
part 'list_state.dart';
String token = "";
class ListBloc extends Bloc<ListEvent, ListState> {
  
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      if(state is! ListLoading){
        emit(ListLoading());
        try {
          List? users = await loadUsers();
          if(users != null) {
            emit(ListLoaded(users as List<UserItem>));
          }
          else{
            List<UserItem> users2 = [];
             emit(ListLoaded(users2));
          }
          } 
          on ListException catch (e) {
            emit(ListError(e.message));
        }
    
  }
    });
  
  }
  
  Future<List<dynamic>?> loadUsers() async {
    String? token = GetIt.I<MyToken>().token;
  try {
    final dio = GetIt.I<Dio>();
     dio.options.headers = {'Authorization': 'Bearer $token'};
      final Response response = await dio.get(
        '/users',
      );
    return (response.data as List).map((item) => UserItem(item['name'], item['avatarUrl'])).toList();
  } catch(e) {
    if (e is DioException) {
        throw ListException(e.response!.data['message'] as String);
      } else {
        throw ListException(e.toString());
      }
  }
}


  Future<String> getTokenFromSharedPreferences() async {
    return GetIt.I<SharedPreferences>().getString('token') ?? "";
  }
  Future<void> removeTokenFromSharedPreference() async {
    await GetIt.I<SharedPreferences>().remove('token');
    
  }


}