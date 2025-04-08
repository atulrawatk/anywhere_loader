import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
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
  Color _progressColor = Colors.blue;
  Color _backgroundColor = Colors.black;
  double _opacity = 0.3;
  double _blurSigma = 5.0;
  bool _isIos=false;
  double _iosProgressRadius=13;

  /// Starts the loader with optional customization and timeout
  void startLoader({
    String? text,
    int seconds = 10,
    double? fontSize,
    Color? fontColor,
    String? fontFamily,
    Widget? customWidget,
    Color? progressColor,
    Color? backgroundColor,
    double? opacity,
    double? blurSigma,
    bool? isIos,
    double? iosProgressRadius
  }) {
    if (_isShowing) return; // Prevent duplicate loaders

    // Set loader content and styles
    _text = text ?? "Loading...";
    _customWidget = customWidget;
    _fontSize = fontSize;
    _fontColor = fontColor;
    _fontFamily = fontFamily;
    _progressColor = progressColor ?? Colors.blue;
    _backgroundColor = backgroundColor ?? Colors.black;
    _opacity = opacity ?? 0.3;
    _blurSigma = blurSigma ?? 5.0;
    _isIos=isIos??false;
    _iosProgressRadius=iosProgressRadius??13;
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
    Color? progressColor,
    Color? backgroundColor,
    double? opacity,
    double? blurSigma,
  }) async {
    startLoader(
      text: text,
      seconds: seconds,
      fontSize: fontSize,
      fontColor: fontColor,
      fontFamily: fontFamily,
      customWidget: customWidget,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      opacity: opacity,
      blurSigma: blurSigma,
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
          filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma), // Blur effect
          child: Container(
            color: _backgroundColor.withAlpha((_opacity.clamp(0.0, 1.0) * 255).toInt()), // Custom opacity
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: _customWidget ?? _defaultLoader(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Default loading indicator with spinner and text
  Widget _defaultLoader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isIos?
          CupertinoActivityIndicator(
            radius: _iosProgressRadius,
            color: _progressColor,
          )
              :CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
          ),
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
      ),
    );
  }
}
