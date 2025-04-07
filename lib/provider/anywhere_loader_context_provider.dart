import 'package:flutter/material.dart';
import '../anywhere_loader.dart';

/// A wrapper widget to provide a global BuildContext to AnyWhereLoader
///
/// This allows the loader to access the `Overlay` without needing to pass
/// context manually or use GetMaterialApp.
class AnyWhereLoaderContextProvider extends StatefulWidget {
  /// The widget subtree that this provider wraps
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

    // Capture and store the context for overlay use if not already set
    if (AnyWhereLoader.context == null) {
      AnyWhereLoader.context = context;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simply return the child widget without modification
    return widget.child;
  }
}
