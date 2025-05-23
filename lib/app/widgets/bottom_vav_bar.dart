// ignore_for_file: unused_field, unused_element, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/favorite/screen/favorite.dart';
import 'package:graduation/features/home/ui/screens/home.dart';
import 'package:graduation/features/settings/ui/screens/setting.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _isRtl = true;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [Homescreen(), const Favorite(), const Setting()];
  }

  void _determineAnimationDirection(int newIndex) {
    bool forward = newIndex > _selectedIndex;
    if (_isRtl) {
      forward = !forward;
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: const Color(0xffA2A2A2),
        showUnselectedLabels: true,
        elevation: 10,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.home, 0), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.favorite, 1), label: 'المفضلة'),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.settings, 2), label: 'الإعدادات'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsManager.kPrimaryColor,
        onTap: _onItemTapped,
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(_selectedIndex == index ? 8.0 : 0.0),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? ColorsManager.kPrimaryColor.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: _selectedIndex == index ? ColorsManager.kPrimaryColor : ColorsManager.gray,
        size: _selectedIndex == index ? 28.0 : 24.0,
      ),
    );
  }
}
