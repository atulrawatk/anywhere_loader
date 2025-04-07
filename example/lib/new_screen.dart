import 'package:flutter/material.dart';
import 'package:anywhere_loader/anywhere_loader.dart';
import 'package:anywhere_loader/anywhere_loader_context_provider.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AnyWhereLoader.instance.startLoader(text: "Please wait...");
            Future.delayed(const Duration(seconds: 3), () {
              AnyWhereLoader.instance.stopLoader();
            });
          },
          child: const Text("Show Loader in next screen"),
        ),
      ),
    );
  }
}
