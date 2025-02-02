import 'package:flutter/material.dart';

// CustomButton widget
class CustomButton extends StatelessWidget {
  final String text; // The text on the button
  final VoidCallback
      onPressed; // The function to call when the button is pressed
  final Color color; // Background color of the button
  final double width; // Width of the button
  final double height; // Height of the button
  final TextStyle? textStyle; // Style for the text

  // Constructor with named parameters
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // Default color
    this.width = double.infinity, // Default full width
    this.height = 50.0, // Default height
    this.textStyle, // Optionally, custom text style
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          elevation: 5, // Add shadow
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                  color: Colors.white, fontSize: 16), // Default text style
        ),
      ),
    );
  }
}
