import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/reported_cars/logic/cubit/reported_cars_cubit.dart';
import 'package:graduation/features/reported_cars/ui/screens/reported_cars.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ColorsManager.kPrimaryColor,
        title: SizedBox(
          height: 50,
          // child: Hero(
          // tag: "logo",
          // child: KSvgIcon(
          //   Assets.icon.logoIcon.path,
          //   color: ColorsManager.white,
          //   // size: 134,
          // ),
        ),
        // ),
      ),
      body: Column(
        children: [
          KSettingListTile(title: 'الملف الشخصي', icon: Icon(Icons.person), onTap: () => {}),
          const Divider(height: 0),
          KSettingListTile(
            title: 'السيارات المبلغ عنها',
            icon: Icon(Icons.car_crash_outlined),
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
          ),
          const Divider(height: 0),
          KSettingListTile(title: 'تغير كلمة المرور', icon: Icon(Icons.lock), onTap: () => {}),
          const Divider(height: 0),
          context.isLoggedIn
              ? KSettingListTile(title: 'تسجيل الخروج', icon: Icon(Icons.logout_outlined), onTap: () => {})
              : const Divider(height: 0),

          const SizedBox(height: 10),
          TextButton(
            onPressed: () => (),
            child: Text(
              'Register Now',
              // style: context.textTheme.bodyLarge?.copyWith(
              //   fontSize: 15,
              //   color: ColorsManager.kPrimaryColor,
              //   fontWeight: FontWeight.w500,
              // ),
            ),
          ),

          const Divider(height: 0),
          TextButton(
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => KCustomDialouge(
              //     title: S.of(context).are_you_sure_you_want_to_delete_your_account,
              //     action: S.of(context).delete_account,
              //     onTap: () {
              //       context.read<AccountBloc>().add(const AccountEvent.deleteAccount());
              //     },
              //   ),
              // );
            },
            child: Text(
              '        S.of(context).delete_account',
              // style: context.textTheme.bodyMedium?.copyWith(fontSize: 15, color: ColorsManager.red),
            ),
          ),
        ],
      ),
    );
  }
}

class KSettingListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const KSettingListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: icon,
        title: Text(title, style: const TextStyle(fontSize: 15, color: ColorsManager.dark)),
        trailing: const Icon(Icons.arrow_forward_ios, color: ColorsManager.kPrimaryColor),
        onTap: onTap,
      ),
    );
  }
}
