import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// A globally accessible loader that can be shown anywhere in the app
class AnyWhereLoader {
  /// Required to access the Overlay — must be set before using the loader
  static BuildContext? context;

  /// Singleton instance
  static final AnyWhereLoader instance = AnyWhereLoader._internal();
  AnyWhereLoader._internal();

  /// Holds the overlay that displays the loader
  OverlayEntry? _overlayEntry;

  /// Timer to auto-stop the loader after a set duration
  Timer? _timer;

  /// Whether the loader is currently shown
  bool _isShowing = false;

  /// Loader customization options
  String? _text;
  Widget? _customWidget;
  double? _fontSize;
  Color? _fontColor;
  String? _fontFamily;

  /// Starts the loader with optional customization and timeout
  void startLoader({
    String? text,
    int seconds = 10,
    double? fontSize,
    Color? fontColor,
    String? fontFamily,
    Widget? customWidget,
  }) {
    if (_isShowing) return; // Prevent duplicate loaders

    // Set loader content and styles
    _text = text ?? "Loading...";
    _customWidget = customWidget;
    _fontSize = fontSize;
    _fontColor = fontColor;
    _fontFamily = fontFamily;

    // Create and show the overlay
    _overlayEntry = _createOverlay();
    Overlay.of(context!).insert(_overlayEntry!);
    _isShowing = true;

    // Auto-stop after given time
    _timer = Timer(Duration(seconds: seconds), () => stopLoader());
  }

  /// Stops and removes the loader
  void stopLoader() {
    if (!_isShowing) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer?.cancel();
    _isShowing = false;
  }

  /// Wraps an async function and shows loader during its execution
  Future<void> showAsyncLoader({
    required Future<void> Function() asyncFunction,
    String? text,
    int seconds = 10,
    double? fontSize,
    Color? fontColor,
    String? fontFamily,
    Widget? customWidget,
  }) async {
    startLoader(
      text: text,
      seconds: seconds,
      fontSize: fontSize,
      fontColor: fontColor,
      fontFamily: fontFamily,
      customWidget: customWidget,
    );
    try {
      await asyncFunction();
    } finally {
      stopLoader();
    }
  }

  /// Creates the overlay entry that blurs the background and shows the loader
  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.3), // Semi-transparent background
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _customWidget ?? _defaultLoader(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Default loading indicator with spinner and text
  Widget _defaultLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(
          _text ?? "",
          style: TextStyle(
            fontSize: _fontSize ?? 16,
            color: _fontColor ?? Colors.white,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}
