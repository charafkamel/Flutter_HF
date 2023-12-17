
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
    
  //_listBloc = BlocProvider.of<ListBloc>(context);
  //  BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
  }
  @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => ListBloc(),
    child: BlocConsumer<ListBloc, ListState>(
      builder: (context, state) {
         if (state is ListLoading || state is ListInitial){
          BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
          return Scaffold(
            appBar: AppBar(
              title: Text('User List'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    BlocProvider.of<ListBloc>(context).removeTokenFromSharedPreference();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
             body: const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
            ),
            );
        }
          else if (state is ListLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text('User List'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    BlocProvider.of<ListBloc>(context).removeTokenFromSharedPreference();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
            body: Material(
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(state.users[index].avatarUrl),
                    title: Text(state.users[index].name),
                  );
                },
              ),
            ),
          );
        }

        return Container();
      },
      listener: (context, state) {
        if (state is ListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },

    ),
  );
}
}