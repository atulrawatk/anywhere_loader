import 'package:flutter/material.dart';
import '../anywhere_loader.dart';

class AnyWhereLoaderContextProvider extends StatefulWidget {
  final Widget child;
  const AnyWhereLoaderContextProvider({Key? key, required this.child})
      : super(key: key);

  @override
  State<AnyWhereLoaderContextProvider> createState() =>
      _AnyWhereLoaderContextProviderState();
}

class _AnyWhereLoaderContextProviderState
    extends State<AnyWhereLoaderContextProvider> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capture the context only once
    if (AnyWhereLoader.context == null) {
      AnyWhereLoader.context = context;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
