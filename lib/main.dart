import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musical_tiles/home_screen.dart';
import 'package:musical_tiles/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage localStorage = await LocalStorage.getInstance();
  Get.put(localStorage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Musical Tile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
