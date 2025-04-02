import 'package:flutter/material.dart';
import 'package:anywhere_loader/anywhere_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Overlay Loader Demo")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await AnyWhereLoader.instance.runWithLoader(
                asyncFunction: () async {
                  await Future.delayed(const Duration(seconds: 5));
                },
                text: "Loading, please wait...",
              );
            },
            child: const Text("Show Loader"),
          ),
        ),
      ),
    );
  }
}
