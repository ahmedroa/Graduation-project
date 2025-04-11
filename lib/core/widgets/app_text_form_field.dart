// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final int? maxLength;
  final Function(String)? onChanged;
  final void Function()? onTap;
  final String? helperText;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? counter;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? readOnly; // 🔹 إضافة متغير readOnly
  final FocusNode? focusNode;
  final bool? enabled;

  const AppTextFormField({
    super.key,
    this.keyboardType,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.enabled,
    this.controller,
    required this.validator,
    this.fillColor,
    this.maxLength,
    this.onChanged,
    this.helperText,
    this.prefixText,
    this.borderRadius,
    this.prefixIcon,
    this.inputFormatters,
    this.onTap,
    this.counter,
    this.maxLines,
    this.textAlign,
    this.readOnly,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: keyboardType,
      controller: controller,
      style: TextStyles.font14GrayRegular.copyWith(color: Theme.of(context).colorScheme.secondary),
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      obscureText: isObscureText ?? false,
      validator: validator,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        helperText: helperText,
        suffixText: prefixText,
        counter: counter,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.kPrimaryColor, width: 1.3),
              borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
              borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        ),

        hintText: hintText,
        helperStyle: const TextStyle(color: Color(0xffA2A2A2)),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: fillColor ?? Theme.of(context).colorScheme.primaryContainer,
        filled: true,
      ),
    );
  }
}
