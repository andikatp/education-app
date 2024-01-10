import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/core/common/app/providers/tab_navigator.dart';

class PesistentView extends StatefulWidget {
  const PesistentView({this.body, super.key});

  final Widget? body;

  @override
  State<PesistentView> createState() => _PesistentViewState();
}

class _PesistentViewState extends State<PesistentView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentPage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
