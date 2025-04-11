import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/build_divider.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
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
            _buildSignInHeader(),
            verticalSpace(20),
            _buildReportSection(),
            verticalSpace(20),
            _buildSettingsMenu(),
            verticalSpace(20),
            _buildLogoutButton(),
            verticalSpace(20),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInHeader() {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _headerAnimation.value,
          child: Opacity(opacity: _headerAnimation.value, child: child),
        );
      },
      child: Container(
        height: 230,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الملف الشخصي', style: TextStyles.font20DarkBold),
                    Text(
                      'يرجى تسجيل الدخول للتطبيق لتحديث معلوماتك الشخصية بسهولة وخصوصية.',
                      style: TextStyles.font14GrayMedium,
                    ),
                    verticalSpace(12),
                    MainButton(text: 'سجل دخول', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
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
            showModalBottomSheet(
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
                  onTap: () => context.pushNamed(Routes.profile),
                  index: 0,
                ),
                BuildDivider(),
                _buildAnimatedListTile(
                  title: 'السيارات المبلغ عنها',
                  icon: Icons.car_crash_outlined,
                  onTap: () => {},
                  index: 1,
                ),
                BuildDivider(),
                _buildAnimatedListTile(
                  title: 'تغير كلمة المرور',
                  icon: Icons.lock,
                  onTap: () => notRegistered(context),
                  index: 2,
                ),
                BuildDivider(),
                _buildAnimatedListTile(title: 'مشاركة التطبيق', icon: Icons.share, onTap: () {}, index: 3),
                context.isNotLoggedIn
                    ? const SizedBox.shrink()
                    : _buildAnimatedListTile(
                      title: 'تسجيل الخروج',
                      icon: Icons.logout_outlined,
                      onTap: () {},
                      index: 4,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
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
    );
  }

  Widget _buildDeleteAccountButton() {
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

  Widget _buildAnimatedListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
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

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
    );
  }
}
