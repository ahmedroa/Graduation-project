import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/build_divider.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/settings/logic/cubit/settings_cubit.dart';
import 'package:graduation/features/settings/ui/widgets/build_delete_account_button.dart';
import 'package:graduation/features/settings/ui/widgets/build_sign_in_header.dart';
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
    _initAnimations();
  }

  void _initAnimations() {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            context.isNotLoggedIn ? BuildSignInHeader(headerAnimation: _headerAnimation) : verticalSpace(90),

            verticalSpace(20),
            _buildReportSection(),
            verticalSpace(20),
            _buildSettingsMenu(),
            verticalSpace(20),
            _buildLogoutButton(),
            verticalSpace(20),
            BuildDeleteAccountButton(
              deleteButtonAnimation: _deleteButtonAnimation,
              controller: _controller,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection() {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.5, 0.0), end: Offset.zero).animate(
              CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic)),
            ),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () {
            context.isNotLoggedIn
                ? notRegistered(context)
                : showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => AddPostBottomSheet(),
                );
          },
          child: Container(
            height: 120,
            decoration: _buildContainerDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Icon(Icons.car_crash, color: ColorsManager.kPrimaryColor),
                  ),
                  horizontalSpace(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('أبلغ عن سيارتك المفقودة', style: TextStyles.font16DarkBold),
                      verticalSpace(4),
                      Text(
                        'قم بإدخال تفاصيل سيارتك المفقودة ،\n وسنساعدك في البحث عنها.',
                        style: TextStyles.font14GrayMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 700),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(8.0 * (1.0 - value), 0.0),
                        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                      );
                    },
                    child: Icon(Icons.arrow_forward_ios, color: ColorsManager.kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: _buildContainerDecoration(),
            child: Column(
              children: [
                _buildAnimatedListTile(
                  title: 'الملف الشخصي',
                  icon: Icons.person,
                  onTap: () {
                    context.isNotLoggedIn ? notRegistered(context) : context.pushNamed(Routes.profile);
                  },
                  // context.pushNamed(Routes.profile),
                  index: 0,
                ),
                BuildDivider(),
                _buildAnimatedListTile(
                  title: 'السيارات المبلغ عنها',
                  icon: Icons.car_crash_outlined,
                  onTap: () {
                    context.isNotLoggedIn ? notRegistered(context) : context.pushNamed(Routes.reportedCars);
                  },
                  index: 1,
                ),
                BuildDivider(),

                _buildAnimatedListTile(title: 'مشاركة التطبيق', icon: Icons.share, onTap: () {}, index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          state.whenOrNull(
            logoutSuccess: () {
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.splashView, (route) => false);
            },
            logoutFailure: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('حدث خطأ في تسجيل الخروج: $error'), backgroundColor: Colors.red));
            },
          );
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return state.maybeWhen(
              loggingOut: () => const Center(child: CircularProgressIndicator()),
              orElse:
                  () => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text('تأكيد تسجيل الخروج'),
                            content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  context.read<SettingsCubit>().logout();
                                },
                                child: Text('تسجيل الخروج', style: TextStyle(color: ColorsManager.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: _buildContainerDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout_outlined, color: ColorsManager.red),
                              horizontalSpace(20),
                              Text('تسجيل الخروج', style: TextStyles.font16DarkBold),
                              const Spacer(),
                              Icon(Icons.arrow_forward_ios, color: ColorsManager.kPrimaryColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double maxEnd = 0.9;
        final double itemsCount = 5.0;

        final double startBase = 0.5;
        final double totalDuration = maxEnd - startBase;
        final double step = totalDuration / itemsCount;

        final double start = startBase + (index * step);
        final double end = (start + step).clamp(0.0, maxEnd);

        final Animation<double> itemAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOut)));

        return Transform.translate(
          offset: Offset(50 * (1 - itemAnimation.value), 0),
          child: Opacity(opacity: itemAnimation.value.clamp(0.0, 1.0), child: child),
        );
      },
      child: KSettingListTile(title: title, icon: Icon(icon), onTap: onTap),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8));
  }
}
