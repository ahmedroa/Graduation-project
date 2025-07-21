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
import 'package:graduation/features/posts/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/settings/logic/cubit/settings_cubit.dart';
import 'package:graduation/features/settings/ui/widgets/build_delete_account_button.dart';
import 'package:graduation/features/settings/ui/widgets/build_sign_in_header.dart';
import 'package:graduation/features/settings/ui/widgets/k_setting_list_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            context.isNotLoggedIn ? BuildSignInHeader() : verticalSpace(90),

            verticalSpace(20),
            _buildReportSection(),
            verticalSpace(20),
            _buildSettingsMenu(),
            verticalSpace(20),
            context.isNotLoggedIn ? SizedBox() : _buildLogoutButton(),
            verticalSpace(20),
            context.isNotLoggedIn ? SizedBox() : BuildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection() {
    return Padding(
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
                Icon(Icons.car_crash, color: ColorsManager.kPrimaryColor),
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
                Icon(Icons.arrow_forward_ios, color: ColorsManager.kPrimaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _buildContainerDecoration(),
        child: Column(
          children: [
            _buildListTile(
              title: 'الملف الشخصي',
              icon: Icons.person,
              onTap: () {
                context.isNotLoggedIn ? notRegistered(context) : context.pushNamed(Routes.profile);
              },
            ),
            BuildDivider(),
            _buildListTile(
              title: 'السيارات المبلغ عنها',
              icon: Icons.car_crash_outlined,
              onTap: () {
                context.isNotLoggedIn ? notRegistered(context) : context.pushNamed(Routes.reportedCars);
              },
            ),
            BuildDivider(),
            _buildListTile(
              title: 'حساب المطور',
              icon: Icons.person_outline,
              onTap: () async {
                final url = Uri.parse('https://www.instagram.com/dev__ahmed10/#');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),

            BuildDivider(),
            _buildListTile(
              title: 'مشاركة التطبيق',
              icon: Icons.share,
              onTap: () {
                Share.share(
                  'تطبيق " لقيناها" يساعدك في العثور على سيارتك المفقودة أو المسروقة في السودان.\n https://lageenaha.erbut.me/',
                  subject:
                      'تطبيق " لقيناها" يساعدك في العثور على سيارتك المفقودة أو المسروقة في السودان.\n https://lageenaha.erbut.me/',
                );
              },
            ),
            BuildDivider(),
            _buildListTile(
              title: 'سياسة الخصوصية',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                context.pushNamed(Routes.termsScreen);
              },
            ),
          ],
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

  Widget _buildListTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return KSettingListTile(title: title, icon: Icon(icon), onTap: onTap);
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8));
  }
}
