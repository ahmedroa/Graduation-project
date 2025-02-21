// ignore_for_file: unused_field, unused_element, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/home/ui/screens/home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List _widgetOptions = [Homescreen(), Container(), Container()];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _onItemTapped(int index) {
    setState(() {
      print(_selectedIndex);

      _selectedIndex = index;
    });
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: const Color(0xffA2A2A2),
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _selectedIndex == 1 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: _selectedIndex == 2 ? ColorsManager.kPrimaryColor : ColorsManager.gray),
            label: 'الإعدادات',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsManager.kPrimaryColor,
        onTap: _onItemTapped,
      ),
      body: FadeTransition(opacity: _animation, child: Center(child: _widgetOptions.elementAt(_selectedIndex))),
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

//   final List _widgetOptions = [
//     Homescreen(),
//     Container(),
//     Container(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         unselectedItemColor: const Color(0xffA2A2A2),
//         showUnselectedLabels: true,
//         elevation: 0,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: _selectedIndex == 0 ? ColorsManager.kPrimaryColor : ColorsManager.gray,
//             ),
//             label: 'الرئيسية',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.favorite,
//               color: _selectedIndex == 1 ? ColorsManager.kPrimaryColor : ColorsManager.gray,
//             ),
//             label: 'المفضلة',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.settings,
//               color: _selectedIndex == 2 ? ColorsManager.kPrimaryColor : ColorsManager.gray,
//             ),
//             label: 'الإعدادات',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: ColorsManager.kPrimaryColor,
//         onTap: _onItemTapped,
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//     );
//   }
// }
