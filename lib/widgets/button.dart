import 'package:flutter/material.dart';
import 'package:stackz/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final Color color;

  // Optional overall size
  final double? buttonWidth;
  final double? buttonHeight;

  // Internal padding
  final double horizontalPadding;
  final double verticalPadding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppTheme.primaryColor,
    this.enabled = true,
    this.buttonWidth,
    this.buttonHeight,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 12.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding,
        ),
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: Size(
          widget.buttonWidth ?? 0,
          widget.buttonHeight ?? 0,
        ), // ensures button respects optional width/height
      ),
      onPressed: widget.enabled ? widget.onPressed : null,
      child: Text(
        widget.label,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );

    // Wrap in SizedBox if width/height is specified to force exact size
    if (widget.buttonWidth != null || widget.buttonHeight != null) {
      button = SizedBox(
        width: widget.buttonWidth,
        height: widget.buttonHeight,
        child: button,
      );
    }

    return button;
  }
}
