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
        emit(ListLoading());
        try {
          print("ITt még igen?");
          List<UserItem>? users = (await loadUsers());
          print("BEMEGY :D");
          emit(ListLoaded(users!));
          print("Nem tudja atloadolni?!");
          } 
          catch (e) {
            print("MEEE");
            emit(ListError(e.toString()));
        }
    
  
    });
  }
  
  Future<List<UserItem>?> loadUsers() async {
    String? token = GetIt.I<MyToken>().token;
  try {
    print("a");
    final dio = GetIt.I<Dio>();
    print("aa");
     dio.options.headers = {'Authorization': 'Bearer $token'};
     print("aaa");
      final Response response = await dio.get(
        '/users',
      );
    // Data exists, process it
    //print("RESPONSE: ${response.data}");
    print("Return értéke: ${response.data.map((item) => UserItem(item['name'], item['avatarUrl'])).toList()}");
    return response.data.map((item) => UserItem(item['name'], item['avatarUrl'])).toList();
  } catch(e) {
    // Data does not exist, handle the error
    print("TEEE");
    throw ListException(e.toString());
  }
}


  Future<String> getTokenFromSharedPreferences() async {
    return GetIt.I<SharedPreferences>().getString('token') ?? "";
  }
  Future<void> removeTokenFromSharedPreference() async {
    print("BEFORE DELETE: ${GetIt.I<SharedPreferences>().getString('token') ?? ""}");
    await GetIt.I<SharedPreferences>().remove('token');
    
  }


}