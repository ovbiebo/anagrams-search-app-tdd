import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'features/anagram_finder/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anagrams',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}