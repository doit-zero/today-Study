// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'screens/todaylist.dart';
import 'package:provider/provider.dart';
import './screens/recordlist.dart';
import 'package:intl/date_symbol_data_local.dart';
import './Stores/store1.dart';
import './Stores/store2.dart';

void main() async {
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Store1()),
        ChangeNotifierProvider(create: (context) => Store2()),
      ],
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tap = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('오늘의 공부'),
      ),
      body: [const TodayList(), const RecordList()][tap],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            tap = value;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.black87,
            ),
            label: 'Today List',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined, color: Colors.black87),
            label: 'Completed List',
          ),
        ],
        selectedLabelStyle: const TextStyle(color: Colors.black26),
        unselectedLabelStyle: const TextStyle(color: Colors.black26),
      ),
    );
  }
}
