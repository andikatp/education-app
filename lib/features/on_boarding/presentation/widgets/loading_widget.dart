import 'package:flutter/material.dart';
import 'package:teacher/core/extensions/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              context.theme.colorScheme.secondary,),
        ),
      ),
    );
  }
}
