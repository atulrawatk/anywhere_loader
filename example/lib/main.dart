import 'package:anywhere_loader/provider/anywhere_loader_context_provider.dart';
import 'package:example/new_screen.dart';
import 'package:flutter/material.dart';
import 'package:anywhere_loader/anywhere_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnyWhereLoaderContextProvider(
          child: HomePage(),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anywhere Loader Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AnyWhereLoader.instance.startLoader(text: "Please wait...");
                Future.delayed(const Duration(seconds: 3), () {
                  AnyWhereLoader.instance.stopLoader();
                });
              },
              child: const Text("Show Loader"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AnyWhereLoader.instance.showAsyncLoader(
                  asyncFunction: () async {
                    await Future.delayed(const Duration(seconds: 5));
                  },
                  text: "Loading data...",
                );
              },
              child: const Text("Run Async Loader"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NewScreen()));
              },
              child: const Text("NextScreen"),
            ),
          ],
        ),
      ),
    );
  }
}
