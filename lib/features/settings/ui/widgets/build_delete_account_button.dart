import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/settings/logic/cubit/settings_cubit.dart';

class BuildDeleteAccountButton extends StatelessWidget {
  const BuildDeleteAccountButton({
    super.key,
    required Animation<double> deleteButtonAnimation,
    required AnimationController controller,
    required this.context,
  }) : _deleteButtonAnimation = deleteButtonAnimation,
       _controller = controller;

  final Animation<double> _deleteButtonAnimation;
  final AnimationController _controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          state.whenOrNull(
            deleteAccountSuccess: () {
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.splashView, (route) => false);
            },
            deleteAccountFailure: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('حدث خطأ في حذف الحساب: $error'), backgroundColor: Colors.red));
            },
          );
        },
        child: AnimatedBuilder(
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
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const CircularProgressIndicator(),
                orElse:
                    () => TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('تأكيد حذف الحساب'),
                              content: const Text(
                                'هل أنت متأكد من رغبتك في حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.',
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context.read<SettingsCubit>().deleteAccount();
                                  },
                                  child: Text('حذف', style: TextStyle(color: ColorsManager.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('حذف الحساب', style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.red)),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// class BuildDeleteAccountButton extends StatelessWidget {
//   const BuildDeleteAccountButton({
//     super.key,
//     required Animation<double> deleteButtonAnimation,
//     required AnimationController controller,
//     required this.context,
//   }) : _deleteButtonAnimation = deleteButtonAnimation,
//        _controller = controller;

//   final Animation<double> _deleteButtonAnimation;
//   final AnimationController _controller;
//   final BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SettingsCubit(),
//       child: AnimatedBuilder(
//         animation: _deleteButtonAnimation,
//         builder: (context, child) {
//           final opacity = _deleteButtonAnimation.value.clamp(0.0, 1.0);

//           return Transform.scale(
//             scale: _deleteButtonAnimation.value.clamp(0.0, 1.0),
//             child: Opacity(
//               opacity: opacity,
//               child: SlideTransition(
//                 position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
//                   CurvedAnimation(parent: _controller, curve: const Interval(0.9, 1.0, curve: Curves.easeOutCubic)),
//                 ),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: TextButton(
//           onPressed: () => context.read<SettingsCubit>().deleteAccount(),
//           child: Text('حذف الحساب', style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.red)),
//         ),
//       ),
//     );
//   }
// }
