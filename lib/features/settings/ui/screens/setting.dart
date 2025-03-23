import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/features/reported_cars/logic/cubit/reported_cars_cubit.dart';
import 'package:graduation/features/reported_cars/ui/screens/reported_cars.dart';
import 'package:graduation/features/settings/ui/widgets/k_setting_list_tile.dart';

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
        title: SvgPicture.asset(ImgManager.logo, width: 50),
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
          context.isNotLoggedIn
              ? KSettingListTile(title: 'تسجيل الخروج', icon: Icon(Icons.logout_outlined), onTap: () => {})
              : const Divider(height: 0),

          const SizedBox(height: 10),

          context.isNotLoggedIn
              ? TextButton(onPressed: () => (), child: Text('Register Now'))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
