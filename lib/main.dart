import 'package:flutter/material.dart';
import 'screens/editor_screen.dart';

void main() {
  runApp(const PhotoEditApp());
}

class PhotoEditApp extends StatelessWidget {
  const PhotoEditApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Photo Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const EditorScreen(),
    );
  }
}
