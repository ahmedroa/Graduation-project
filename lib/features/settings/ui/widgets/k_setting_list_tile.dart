import 'package:flutter/material.dart';

import 'package:graduation/core/theme/colors.dart';

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
