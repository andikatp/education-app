import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/core/common/app/providers/tab_navigator.dart';

class PersistentPage extends StatefulWidget {
  const PersistentPage({this.body, super.key});

  final Widget? body;

  @override
  State<PersistentPage> createState() => _PersistentPageState();
}

class _PersistentPageState extends State<PersistentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentPage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
