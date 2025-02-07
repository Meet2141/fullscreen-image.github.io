import 'dart:html' as html; // Importing Dart's HTML library for DOM manipulation
import 'dart:ui' as ui; // Importing UI library for platform view registration

import 'package:flutter/material.dart'; // Importing Flutter material package

void main() {
  runApp(const MyApp()); // Entry point of the application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fullscreen Image App', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Setting the primary theme color
      ),
      home: const FullscreenImageApp(), // Main screen widget
    );
  }
}

class FullscreenImageApp extends StatefulWidget {
  const FullscreenImageApp({super.key});

  @override
  State<FullscreenImageApp> createState() => _FullscreenImageAppState();
}

class _FullscreenImageAppState extends State<FullscreenImageApp> {
  final TextEditingController _urlController = TextEditingController(); // Controller to handle URL input
  String? _imageUrl; // Variable to store the entered image URL

  // Function to toggle fullscreen mode
  void _toggleFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen(); // Exit fullscreen if already in fullscreen mode
    } else {
      html.document.documentElement?.requestFullscreen(); // Enter fullscreen mode
    }
  }

  // Function to enter fullscreen mode
  void _enterFullscreen() {
    html.document.documentElement?.requestFullscreen();
  }

  // Function to exit fullscreen mode
  void _exitFullscreen() {
    html.document.exitFullscreen();
  }

  // Function to show popup menu with fullscreen options
  void _showPopupMenu() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
      barrierColor: Colors.black54, // Dimming the background
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white, // Dialog background color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: html.ImageElement(src: _imageUrl!)
                          .toWidget(width: 150, height: 150), // Displaying image using HTML <img>
                    ),
                  ElevatedButton(
                    onPressed: () {
                      _enterFullscreen(); // Enter fullscreen on button click
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Enter Fullscreen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _exitFullscreen(); // Exit fullscreen on button click
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Exit Fullscreen'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Setting background color
      appBar: AppBar(
        title: const Text('Fullscreen Image App'), // App bar title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centering content vertically
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _urlController, // Input field for the image URL
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Image URL', // Placeholder text
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _imageUrl = _urlController.text; // Update the image URL state
                });
              },
              child: const Text('Display Image'), // Button to display the image
            ),
            if (_imageUrl != null)
              GestureDetector(
                onDoubleTap: _toggleFullscreen, // Toggle fullscreen on double tap
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: html.ImageElement(src: _imageUrl!)
                      .toWidget(width: 300, height: 300), // Displaying image using HTML <img>
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPopupMenu, // Show popup menu on button click
        child: const Icon(Icons.add), // Plus icon for the button
      ),
    );
  }
}

// Extension to convert HTML ImageElement to Flutter widget
extension on html.ImageElement {
  Widget toWidget({double? width, double? height}) {
    register(); // Register the HTML view
    return SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(
        viewType: 'image-${this.hashCode}', // Unique view type for the image
        key: ValueKey(this.src),
      ),
    );
  }

  // Function to register the HTML view with Flutter
  void register() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'image-${this.hashCode}', // Registering view with a unique ID
      (int viewId) => this, // Returning the image element
    );
  }
}
