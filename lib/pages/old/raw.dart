import 'package:flutter/material.dart';

import '../../ptv/util/urls.dart' as urls;
import '../../ptv/util/request.dart';

class RawResponse extends StatefulWidget {
  const RawResponse({super.key, required this.title});
  final String title;

  @override
  State<RawResponse> createState() => _RawState();
}

class _RawState extends State<RawResponse> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: request(urls.Departures.stop(0, 1111), "max_results=1"), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          final data = snapshot.data.toString();
          return SingleChildScrollView(child: Text(data, style: const TextStyle(fontSize: 5),));
        } else {
          return const Center(child: Text("No data"));
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
