import 'package:flutter/material.dart';

class TextInputForm extends StatefulWidget {
  final double width;
  final String hint;
  final TextEditingController controller;
  final bool hideText;
  final IconData? iconData;
  final int maxLines;
  const TextInputForm({
    super.key,
    required this.width,
    required this.hint,
    required this.controller,
    this.hideText = false,
    this.iconData,
    this.maxLines = 1,
  });

  @override
  State<TextInputForm> createState() => _TextInputFormState();
}

class _TextInputFormState extends State<TextInputForm> {
  bool _obscured = true;

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: widget.hideText ? _obscured : false,
            controller: widget.controller,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon:
                  widget.iconData == null ? null : Icon(widget.iconData),
              hintText: widget.hint,
              filled: true,
              fillColor: Colors.white24,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (widget.hideText)
            IconButton(
              key: const Key('visibilityToggle'),
              icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
              onPressed: _toggleObscured,
            ),
        ],
      ),
    );
  }
}
