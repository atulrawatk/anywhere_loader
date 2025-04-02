# Anywhere Loader

A Flutter package that provides an easy-to-use overlay loader using *GetX*, allowing users to display a loading indicator without manually managing overlays or stacks. The loader supports customization such as font size, color, font family, and custom widgets.

## Features
- 🟢 Uses *Overlay* instead of `Stack` for smooth integration.
- 🎨 Customizable font size, font color, and font family.
- 🔄 Supports async operations.
- 🔍 Blur effect on background while loading.
- 🚀 Simple API: Just wrap your widget and call `startLoader()`.

## Installation

Add this to your **pubspec.yaml**:

yaml
dependencies:
anywhere_loader: latest_version


Then run:
sh
flutter pub get


## Usage

### *1️⃣ Wrap Your App with `AnywhereLoader`*

In your `main.dart`, wrap the app with `AnywhereLoader`:

dart
import 'package:flutter/material.dart';
import 'package:anywhere_loader/anywhere_loader.dart';

void main() {
runApp(AnywhereLoader(
child: MyApp(),
));
}


### *2️⃣ Start and Stop Loader*

To start the loader anywhere in your app:

dart
AnywhereLoader.instance.startLoader(
text: "Loading data...",
seconds: 5, // Default is 10 seconds
fontSize: 18,
fontColor: Colors.white,
fontFamily: 'Arial',
);


To stop the loader manually:

dart
AnywhereLoader.instance.stopLoader();


### *3️⃣ Use Custom Loader Widget*

You can replace the default loader with your own widget:

dart
AnywhereLoader.instance.startLoader(
customWidget: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
CircularProgressIndicator(),
SizedBox(height: 10),
Text("Fetching data...")
],
),
),
);


## License

This package is released under the *MIT License*.

---

Need Help? Create an Issue 🚀