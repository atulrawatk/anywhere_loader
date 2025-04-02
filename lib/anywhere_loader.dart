import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnyWhereLoader extends GetxController {
  static final AnyWhereLoader _instance = Get.put(AnyWhereLoader());

  RxBool isLoading = false.obs;
  RxString loaderText = "".obs;
  RxDouble fontSize = 16.0.obs;
  Rx<Color> textColor = Colors.black.obs;
  RxString fontFamily = ''.obs;
  Widget? _customWidget;
  Timer? _timer;
  OverlayEntry? _overlayEntry;

  static AnyWhereLoader get instance => _instance;

  /// **📌 Start Loader (Sync)**
  void startLoader({
    String? text,
    int seconds = 10,
    double? customFontSize,
    Color? customTextColor,
    String? customFontFamily,
    Widget? customWidget,
  }) {
    if (isLoading.value) return;

    isLoading.value = true;
    loaderText.value = text ?? "Loading...";
    fontSize.value = customFontSize ?? 16.0;
    textColor.value = customTextColor ?? Colors.black;
    fontFamily.value = customFontFamily ?? '';
    _customWidget = customWidget;

    _overlayEntry = _createOverlay();
    Overlay.of(Get.overlayContext!).insert(_overlayEntry!);

    _timer?.cancel();
    _timer = Timer(Duration(seconds: seconds), stopLoader);
  }

  /// **📌 Start Loader for Async Function**
  Future<T> runWithLoader<T>({
    required Future<T> Function() asyncFunction,
    String? text,
    double? customFontSize,
    Color? customTextColor,
    String? customFontFamily,
    Widget? customWidget,
  }) async {
    startLoader(
      text: text,
      customFontSize: customFontSize,
      customTextColor: customTextColor,
      customFontFamily: customFontFamily,
      customWidget: customWidget,
    );

    try {
      return await asyncFunction();
    } finally {
      stopLoader();
    }
  }

  /// **📌 Stop Loader**
  void stopLoader() {
    if (!isLoading.value) return;
    isLoading.value = false;
    loaderText.value = "";
    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer?.cancel();
    _customWidget = null;
  }

  /// **📌 Create Overlay**
  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Color.fromARGB((0.3 * 255).toInt(), 0, 0, 0),
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

  /// **📌 Default Loader**
  Widget _defaultLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Obx(() => Text(
              loaderText.value,
              style: TextStyle(
                fontSize: fontSize.value,
                color: textColor.value,
                fontFamily:
                    fontFamily.value.isNotEmpty ? fontFamily.value : null,
              ),
            )),
      ],
    );
  }
}
