# ⚡ AnywhereLoader – Effortless Overlay Loader Without Context or Dependencies

A lightweight and customizable overlay loader for Flutter. No Stack, no context, no complex state management—just one-line integration to show loaders globally.

## Features

- 🟢 Uses Overlay instead of `Stack` for smooth integration.
- 🎨 Customizable font size, font color, and font family.
- 🔄 Supports async operations.
- 🔍 Blur effect on background while loading.
- 🚀 Simple API: Just wrap your widget and call `startLoader()`.

## Installation

Add this to your **pubspec.yaml**:

```yaml
dependencies:
anywhere_loader: latest_version
```


Then run:

```sh
flutter pub get
```


## Usage

### 1️⃣ ⚙️ Setup

Wrap your screen (not the whole app) inside AnyWhereLoaderContextProvider. This should be placed inside the MaterialApp:

```dart
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
      title: 'Anywhere Loader Demo',
      debugShowCheckedModeBanner: false,
      home: AnyWhereLoaderContextProvider(
        child: HomePage(),
      ),
    );
  }
}
```


### 2️⃣ Start and Stop Loader

To start the loader anywhere in your app:

```dart
AnywhereLoader.instance.startLoader(
  text: "Loading data...",
  seconds: 5, // Default is 10 seconds
  fontSize: 18,
  fontColor: Colors.white,
  fontFamily: 'Arial',
);
```


To stop the loader manually:

```dart
AnywhereLoader.instance.stopLoader();
```

### 3️⃣ Using showAsyncLoader() (Recommended for async calls)
Use this method to automatically show a loader while executing any async function like API calls, database operations, etc.
```dart
await AnyWhereLoader.instance.showAsyncLoader(
 asyncFunction: () async {
 // Simulate a network call or long task
 await Future.delayed(const Duration(seconds: 5));
},
 text: "Loading, please wait...",
);
```
✅ The loader automatically starts and stops.
💡 Ideal for API calls or tasks where you don’t want to manually call startLoader() and stopLoader().


### 4️⃣  Use Custom Loader Widget

You can replace the default loader with your own widget:

```dart
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

```

### 5️⃣ 🍎 Customization for iOS (Cupertino Loader)
You can enable a native iOS-style progress indicator using the isIos: true flag. You can also customize its radius.

```dart
ElevatedButton(
  onPressed: () {
    AnyWhereLoader.instance.startLoader(
      blurSigma: 5,
        backgroundColor: Colors.black,
        opacity: 0.5,
        isIos: true,              // 👈 Enables CupertinoActivityIndicator
        iosProgressRadius: 20,    // 👈 Customize the radius of the Cupertino spinner
        progressColor: Colors.blue, // 👈 Optional color for the Cupertino spinner
        );

        Future.delayed(const Duration(seconds: 3), () {
          AnyWhereLoader.instance.stopLoader();
        });
    },
    child: const Text("Show Loader"),
    );
```
✅ CupertinoActivityIndicator gives a native iOS feel
🎛️ Use isIos: false (default) to switch back to Material spinner
🎯 Great for iOS-specific UI consistency


## License

This package is released under the MIT License.

---