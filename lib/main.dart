import 'package:flutter/material.dart';
import 'package:teacher/core/res/colours.dart';
import 'package:teacher/core/res/fonts.dart';
import 'package:teacher/core/services/injection_container.dart';
import 'package:teacher/core/services/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.poppins,
        appBarTheme: const AppBarTheme(color: Colors.transparent),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
