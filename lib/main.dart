import 'package:appberita/Screen/screen_galery.dart';
import 'package:appberita/Screen/screen_listberita.dart';
import 'package:appberita/Screen/screen_pegawai.dart';
import 'package:appberita/Screen/screen_profile.dart';
import 'package:appberita/Screen/screen_splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: const [
          PageListBerita(),
          GaleryPage(),
          PageProfil(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                tabController.animateTo(0); // Home
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                tabController.animateTo(1); // Gallery
              },
              icon: const Icon(Icons.photo_album),
            ),
            IconButton(
              onPressed: () {
                tabController.animateTo(2); // Employee
              },
              icon: const Icon(Icons.person_2_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
