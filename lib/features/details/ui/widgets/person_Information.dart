import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/ui/details.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonInformation extends StatelessWidget {
  const PersonInformation({super.key, required this.widget});

  final Details widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.person, color: ColorsManager.kPrimaryColor, size: 20.sp),
            horizontalSpace(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.carList?.nameOwner ?? "اسم غير متوفر", style: TextStyles.font16DarkBold),
                Text(widget.carList?.phone ?? "اسم غير متوفر", style: TextStyles.font14DarkRegular),
              ],
            ),
            Spacer(),

            IconButton(
              onPressed: () {
                _showContactOptions(context);
              },
              icon: Icon(Icons.phone, color: ColorsManager.kPrimaryColor, size: 20.sp),
            ),
            horizontalSpace(8),
          ],
        ),
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'اختر طريقة التواصل',
            textAlign: TextAlign.center,
            // style: TextStyles.font18DarkBold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // خيار الاتصال العادي
              ListTile(
                leading: Icon(Icons.phone, color: Color(0xff0070D1)),
                title: Text('اتصال عادي'),
                subtitle: Text('فتح تطبيق الهاتف'),
                onTap: () {
                  Navigator.of(context).pop();
                  _makePhoneCall();
                },
              ),
              Divider(),
              // خيار الواتساب
              ListTile(
                leading: Icon(Icons.chat, color: Color(0xff25D366)),
                title: Text('واتساب'),
                subtitle: Text('إرسال رسالة واتساب'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWhatsApp();
                },
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء'))],
        );
      },
    );
  }
  // widget.carList?.

  Future<void> _makePhoneCall() async {
    final phoneNumber = widget.carList?.phone ?? '';
    if (phoneNumber.isNotEmpty) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      try {
        await launchUrl(phoneUri);
      } catch (e) {
        print('لا يمكن فتح تطبيق الهاتف: $e');
      }
    }
  }

  Future<void> _openWhatsApp() async {
    final phoneNumber = widget.carList?.phone ?? '';
    if (phoneNumber.isNotEmpty) {
      // إزالة الرموز الغير مرغوب فيها من رقم الهاتف
      String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');
      try {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));

        print('لا يمكن فتح الواتساب: $e');
      }
    }
  }
}
