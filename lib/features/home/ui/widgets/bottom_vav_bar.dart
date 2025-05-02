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

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack));

    _screens = [Homescreen(), const Favorite(), const Setting()];

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // تحديد اتجاه التنقل
  void _determineAnimationDirection(int newIndex) {
    bool forward = newIndex > _selectedIndex;

    // للغة العربية، نعكس الاتجاه
    if (_isRtl) {
      forward = !forward;
    }

    // إعادة تعيين الأنيميشن بناءً على الاتجاه
    _slideAnimation = Tween<Offset>(
      begin: Offset(forward ? 1.0 : -1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });

    // تحديد اتجاه الأنيميشن
    _determineAnimationDirection(index);

    // إعادة تشغيل الأنيميشن
    _fadeController.reset();
    _slideController.reset();
    _scaleController.reset();

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على تفضيلات اللغة من النظام
    _isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
      body: AnimatedBuilder(
        animation: Listenable.merge([_fadeController, _slideController, _scaleController]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(scale: _scaleAnimation, child: _screens[_selectedIndex]),
            ),
          );
        },
      ),
    );
  }

  // دالة لإنشاء أيقونة متحركة
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


// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   final List _widgetOptions = [Homescreen(), Favorite(), Setting()];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Theme.of(context).colorScheme.onPrimary,
//         // backgroundColor: ColorsManager.backgroundColor,
//         unselectedItemColor: const Color(0xffA2A2A2),
//         showUnselectedLabels: true,
//         elevation: 10,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: _selectedIndex == 0 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
//             label: 'الرئيسية',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite, color: _selectedIndex == 1 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
//             label: 'المفضلة',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings, color: _selectedIndex == 2 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
//             label: 'الإعدادات',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: ColorsManager.kPrimaryColor,
//         onTap: _onItemTapped,
//       ),
//       body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//     );
//   }
// }
