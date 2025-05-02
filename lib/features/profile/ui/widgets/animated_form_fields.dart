import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';

class AnimatedFormFields extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;

  const AnimatedFormFields({super.key, required this.name, required this.phoneNumber, required this.email});

  @override
  State<AnimatedFormFields> createState() => _AnimatedFormFieldsState();
}

class _AnimatedFormFieldsState extends State<AnimatedFormFields> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _offsets;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (index) => AnimationController(duration: Duration(milliseconds: 400 + (index * 200)), vsync: this),
    );

    _offsets =
        _controllers.map((controller) {
          return Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
        }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _controllers[0],
                child: SlideTransition(
                  position: _offsets[0],
                  child: AppTextFormField(
                    hintText: 'الاسم',
                    initialValue: widget.name,
                    readOnly: true,
                    validator: (v) {
                      return null;
                    },
                  ),
                ),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: FadeTransition(
                opacity: _controllers[1],
                child: SlideTransition(
                  position: _offsets[1],
                  child: AppTextFormField(
                    hintText: 'رقم الجوال',
                    initialValue: widget.phoneNumber,
                    readOnly: true,
                    validator: (v) {
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(12),
        FadeTransition(
          opacity: _controllers[2],
          child: SlideTransition(
            position: _offsets[2],
            child: AppTextFormField(
              hintText: 'الايميل',
              initialValue: widget.email,
              readOnly: true,
              validator: (v) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
