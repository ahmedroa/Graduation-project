import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/reported_cars/logic/cubit/reported_cars_cubit.dart';
import 'package:graduation/features/reported_cars/ui/screens/reported_cars.dart';
import 'package:graduation/features/settings/logic/cubit/settings_cubit.dart';
import 'package:graduation/features/settings/ui/widgets/k_setting_list_tile.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _deleteButtonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic)));

    // تعديل تأثير حركي لزر حذف الحساب - استخدام Curves.easeOut بدلاً من elasticOut
    _deleteButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.9, 1.0, curve: Curves.easeOut)));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _headerAnimation.value,
                child: Opacity(opacity: _headerAnimation.value, child: child),
              );
            },
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    verticalSpace(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الملف الشخصي', style: TextStyles.font20DarkBold),
                          Text(
                            'يرجى تسجيل الدخول للتطبيق لتحديث معلوماتك الشخصية بسهولة وخصوصية.',
                            style: TextStyles.font14GrayMedium,
                          ),
                          verticalSpace(12),
                          MainButton(text: 'سجل دخول', onTap: () => {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          verticalSpace(40),

          FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildAnimatedListTile(title: 'الملف الشخصي', icon: Icons.person, onTap: () => {}, index: 0),
                      buildDivider(),
                      _buildAnimatedListTile(
                        title: 'السيارات المبلغ عنها',
                        icon: Icons.car_crash_outlined,
                        onTap:
                            () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BlocProvider(
                                        create: (context) => ReportedCarsCubit()..getReportedCars(),
                                        child: ReportedCars(),
                                      ),
                                ),
                              ),
                            },
                        index: 1,
                      ),
                      buildDivider(),
                      _buildAnimatedListTile(
                        title: 'تغير كلمة المرور',
                        icon: Icons.lock,
                        onTap: () => {notRegistered(context)},
                        index: 2,
                      ),
                      buildDivider(),
                      _buildAnimatedListTile(title: 'مشاركة التطبيق', icon: Icons.share, onTap: () => {}, index: 3),
                      context.isNotLoggedIn
                          ? SizedBox.shrink()
                          : _buildAnimatedListTile(
                            title: 'تسجيل الخروج',
                            icon: Icons.logout_outlined,
                            onTap: () => {},
                            index: 4,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(20),
          AnimatedBuilder(
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
              onPressed: () {
                context.read<SettingsCubit>().deleteAccount();
              },
              child: Text('حذف الحساب', style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.red)),
            ),
          ),
        ],
      ),
    );
  }

  // كل عنصر من القائمة له تأثير حركي خاص به
  Widget _buildAnimatedListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // حساب تأخير الظهور لكل عنصر على حدة
        final double start = 0.5 + (index * 0.1);
        final double end = start + 0.2;
        final Animation<double> itemAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOut)));

        return Transform.translate(
          offset: Offset(50 * (1 - itemAnimation.value), 0),
          child: Opacity(opacity: itemAnimation.value, child: child),
        );
      },
      child: KSettingListTile(title: title, icon: Icon(icon), onTap: onTap),
    );
  }

  buildDivider() {
    return const Divider(height: 0, color: ColorsManager.grayBorder, thickness: .4);
  }
}
// class Setting extends StatefulWidget {
//   const Setting({super.key});

//   @override
//   State<Setting> createState() => _SettingState();
// }

// class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _headerAnimation;
//   late Animation<double> _opacityAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

//     _headerAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));

//     _opacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic)));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.backgroundColor,
//       body: Column(
//         children: [
//           AnimatedBuilder(
//             animation: _headerAnimation,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _headerAnimation.value,
//                 child: Opacity(opacity: _headerAnimation.value, child: child),
//               );
//             },
//             child: Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     verticalSpace(20),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('الملف الشخصي', style: TextStyles.font20DarkBold),
//                           Text(
//                             'يرجى تسجيل الدخول للتطبيق لتحديث معلوماتك الشخصية بسهولة وخصوصية.',
//                             style: TextStyles.font14GrayMedium,
//                           ),
//                           verticalSpace(12),
//                           MainButton(text: 'سجل دخول', onTap: () => {}),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),
//           FadeTransition(
//             opacity: _opacityAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       _buildAnimatedListTile(
//                         title: 'الملف الشخصي',
//                         icon: Icons.person,
//                         onTap: () => {context.isNotLoggedIn ? notRegistered(context) : SizedBox()},
//                         index: 0,
//                       ),
//                       BuildDivider(),
//                       _buildAnimatedListTile(
//                         title: 'السيارات المبلغ عنها',
//                         icon: Icons.car_crash_outlined,
//                         onTap:
//                             () => {
//                               context.isNotLoggedIn ? notRegistered(context) : SizedBox(),

//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder:
//                               //         (context) => BlocProvider(
//                               //           create: (context) => ReportedCarsCubit()..getReportedCars(),
//                               //           child: ReportedCars(),
//                               //         ),
//                               //   ),
//                               // ),
//                             },
//                         index: 1,
//                       ),
//                       BuildDivider(),
//                       _buildAnimatedListTile(
//                         title: 'تغير كلمة المرور',
//                         icon: Icons.lock,
//                         onTap: () {
//                           context.isNotLoggedIn ? notRegistered(context) : SizedBox();
//                         },
//                         index: 2,
//                       ),
//                       BuildDivider(),
//                       // _buildAnimatedListTile(title: 'مشاركة التطبيق', icon: Icons.share, onTap: () => {}, index: 3),
//                       // context.isNotLoggedIn ? BuildDivider() : SizedBox(),
//                       // context.isNotLoggedIn
//                       //     ? SizedBox.shrink()
//                       //     :
//                       _buildAnimatedListTile(
//                         title: 'تسجيل الخروج',
//                         icon: Icons.logout_outlined,
//                         onTap: () => {},
//                         index: 4,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedListTile({
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//     required int index,
//   }) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final double start = 0.5 + (index * 0.1);
//         final double end = start + 0.2;
//         final Animation<double> itemAnimation = Tween<double>(
//           begin: 0.0,
//           end: 1.0,
//         ).animate(CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOut)));

//         return Transform.translate(
//           offset: Offset(50 * (1 - itemAnimation.value), 0),
//           child: Opacity(opacity: itemAnimation.value, child: child),
//         );
//       },
//       child: KSettingListTile(title: title, icon: Icon(icon), onTap: onTap),
//     );
//   }
// }
