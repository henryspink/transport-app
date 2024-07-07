import 'package:flutter/material.dart';

import '../wrapper/util/urls.dart' as urls;
import '../wrapper/util/request.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: request(urls.Distruptions.all), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          final data = snapshot.data as String;
          return SingleChildScrollView(child: Text(data));
        } else {
          return const Center(child: Text("No data"));
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
