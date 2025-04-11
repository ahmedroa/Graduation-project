

import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.title, required this.subtitle, required this.image});
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value, 
                child: Transform.scale(
                  scale: 0.8 + (value * 0.2), 
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.6,
                  colors: [ColorsManager.kPrimaryColor.withOpacity(0.4), Colors.white.withOpacity(0)],
                ),
              ),
              child: Image.asset(image),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
                  );
                },
                child: Text(title, style: TextStyles.font30BlackBold, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  double opacity = value.clamp(0.0, 1.0);
                  return Opacity(opacity: opacity, child: child);
                },
                child: Text(subtitle, style: TextStyles.font16DarkRegular, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
