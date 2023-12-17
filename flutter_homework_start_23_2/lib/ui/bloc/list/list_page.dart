import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<ListBloc>(context)
                  .removeTokenFromSharedPreference();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(ListState state) {
    if (state is ListLoading || state is ListInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is ListLoaded) {
      return ListView(
        children: state.users.map((user) {
          return ListTile(
            leading: Image.network(user.avatarUrl),
            title: Text(user.name),
          );
        }).toList(),
      );
    }

    return Container();
  }
}
