
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/settings/logic/cubit/settings_cubit.dart';

class BuildDeleteAccountButton extends StatelessWidget {
  const BuildDeleteAccountButton({
    super.key,
    required Animation<double> deleteButtonAnimation,
    required AnimationController controller,
    required this.context,
  }) : _deleteButtonAnimation = deleteButtonAnimation, _controller = controller;

  final Animation<double> _deleteButtonAnimation;
  final AnimationController _controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _deleteButtonAnimation,
      builder: (context, child) {
        final opacity = _deleteButtonAnimation.value.clamp(0.0, 1.0);
    
        return Transform.scale(
          scale: _deleteButtonAnimation.value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: opacity,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
                CurvedAnimation(parent: _controller, curve: const Interval(0.9, 1.0, curve: Curves.easeOutCubic)),
              ),
              child: child,
            ),
          ),
        );
      },
      child: TextButton(
        onPressed: () => context.read<SettingsCubit>().deleteAccount(),
        child: Text('حذف الحساب', style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.red)),
      ),
    );
  }
}
