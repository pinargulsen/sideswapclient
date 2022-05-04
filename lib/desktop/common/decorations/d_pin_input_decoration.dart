import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DPinInputDecoration extends InputDecoration {
  const DPinInputDecoration({
    Widget? icon,
    String? labelText,
    TextStyle? labelStyle,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    int? hintMaxLines,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    bool isCollapsed = false,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? prefix,
    String? prefixText,
    TextStyle? prefixStyle,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool enabled = true,
    String? semanticCounterText,
    bool? alignLabelWithHint,
  }) : super(
          icon: icon,
          labelText: labelText,
          labelStyle: labelStyle,
          helperText: helperText,
          helperStyle: helperStyle,
          helperMaxLines: helperMaxLines,
          hintText: hintText,
          hintStyle: hintStyle,
          hintMaxLines: hintMaxLines,
          errorText: errorText,
          errorStyle: errorStyle,
          errorMaxLines: errorMaxLines,
          floatingLabelBehavior: floatingLabelBehavior,
          isCollapsed: isCollapsed,
          isDense: isDense,
          contentPadding: contentPadding,
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          prefix: prefix,
          prefixText: prefixText,
          prefixStyle: prefixStyle,
          suffixIcon: suffixIcon,
          suffix: suffix,
          suffixText: suffixText,
          suffixStyle: suffixStyle,
          suffixIconConstraints: suffixIconConstraints,
          counter: counter,
          counterText: counterText,
          counterStyle: counterStyle,
          filled: filled,
          fillColor: fillColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          errorBorder: errorBorder,
          focusedBorder: focusedBorder,
          focusedErrorBorder: focusedErrorBorder,
          disabledBorder: disabledBorder,
          enabledBorder: enabledBorder,
          border: border,
          enabled: enabled,
          semanticCounterText: semanticCounterText,
          alignLabelWithHint: alignLabelWithHint,
        );

  @override
  TextStyle? get errorStyle => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFFF7878),
      );

  @override
  String get hintText => super.hintText ?? '';

  @override
  TextStyle get hintStyle =>
      super.hintStyle ??
      GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF84ADC6),
      );

  @override
  Color get fillColor => super.fillColor ?? Colors.white;

  @override
  Color get focusColor => super.focusColor ?? Colors.white;

  @override
  Color get hoverColor => super.hoverColor ?? Colors.white;

  @override
  bool get filled => true;

  @override
  EdgeInsetsGeometry get contentPadding =>
      const EdgeInsets.only(left: 16, top: 18, bottom: 18);

  @override
  InputBorder get border =>
      super.border ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      );

  @override
  InputBorder get focusedBorder =>
      super.focusedBorder ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      );
}
