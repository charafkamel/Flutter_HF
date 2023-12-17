import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_homework/ui/provider/list/list_model.dart';

class ListPageProvider extends StatefulWidget {
  const ListPageProvider({Key? key}) : super(key: key);

  @override
  State<ListPageProvider> createState() => _ListPageProviderState();
}

class _ListPageProviderState extends State<ListPageProvider> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializePage());
  }

  //TODO: Fetch user list from model
  void _initializePage() async {
    
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Missing page!');
  }
}
