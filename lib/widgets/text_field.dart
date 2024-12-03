import 'package:flutter/material.dart';

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hintStyle,
    required this.labelText,
    required this.autofocus,
    required this.readOnly,
    required this.enabled,
    required this.maxLength,
    required this.style,
    required this.borderRadius,
    required this.borderColor,
    required this.fillColor,
    this.focusNode,
    this.contentPadding,
    this.onChanged,
    this.wantBorder,
    required this.decoration,
    this.maxLines,
    this.validator,
  });
  final TextEditingController controller;
  final bool? enabled;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? labelText;
  final bool? autofocus;
  final bool? readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? style;
  final double? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;

  final bool? wantBorder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      enabled: enabled ?? false,
      readOnly: readOnly ?? false,
      style: style ?? const TextStyle(fontSize: 48),
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
        fillColor: fillColor,
        hintText: hintText,
        border: Theme.of(context).inputDecorationTheme.border,
        hintStyle: hintStyle,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      maxLength: maxLength,
      validator: validator,
    );
  }
}
