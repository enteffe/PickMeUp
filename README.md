<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

pick_me_up is an easy to use flutter package that provides a convenient and customizable widget for selecting and displaying image(s) from the device's camera or gallery. It simplifies the process of requesting permissions, picking images, and rendering them in your app.

## Features

Key features of the pick_me_up package include:

- Customizable Appearance: The PickMeUp widget can be customized to match your app's design by adjusting properties such as container size, border radius, border color, and upload button text and icon.
- Permission Handling: The package automatically handles the necessary permissions for accessing the device's camera and photo gallery, making the integration process smoother.
- Image Cropping and Resizing: The package supports optional image cropping and resizing functionality to ensure that the selected images fit within the specified dimensions.
- Reactive State Management: The package utilizes GetX for reactive state management, providing a smooth and efficient user experience.
- Callback for Selected Files: The PickMeUp widget exposes a callback that allows you to receive the selected files and handle them as needed in your application logic.

## Getting started

1. Add pick_me_up in depenedencies
2. run flutter pub get

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.