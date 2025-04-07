import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class AnyWhereLoader {
  static BuildContext? context;
  static final AnyWhereLoader instance = AnyWhereLoader._internal();
  AnyWhereLoader._internal();
  OverlayEntry? _overlayEntry;
  Timer? _timer;
  bool _isShowing = false;
  String? _text;
  Widget? _customWidget;
  double? _fontSize;
  Color? _fontColor;
  String? _fontFamily;
  void startLoader({
    String? text,
    int seconds = 10,
    double? fontSize,
    Color? fontColor,
    String? fontFamily,
    Widget? customWidget,
  }) {
    if (_isShowing) return;
    _text = text ?? "Loading...";
    _customWidget = customWidget;
    _fontSize = fontSize;
    _fontColor = fontColor;
    _fontFamily = fontFamily;
    _overlayEntry = _createOverlay();
    Overlay.of(context!).insert(_overlayEntry!);
    _isShowing = true;
    _timer = Timer(Duration(seconds: seconds), () => stopLoader());
  }

  void stopLoader() {
    if (!_isShowing) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer?.cancel();
    _isShowing = false;
  }

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

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.3),
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
