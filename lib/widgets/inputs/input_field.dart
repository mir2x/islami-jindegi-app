import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.keyboardType,
    this.autofocus = false,
    this.inputFormatters,
    this.decoration,
    this.style,
  });

  final String? initialValue;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final TextStyle? style;

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      decoration: widget.decoration,
      onChanged: widget.onChanged,
      style: widget.style,
    );
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
