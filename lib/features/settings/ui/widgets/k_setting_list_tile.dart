import 'package:flutter/material.dart';

import 'package:graduation/core/theme/colors.dart';


class KSettingListTile extends StatefulWidget {
  final String title;
  final Icon icon;
  final VoidCallback onTap;

  const KSettingListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  State<KSettingListTile> createState() => _KSettingListTileState();
}

class _KSettingListTileState extends State<KSettingListTile> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
          _pressController.forward();
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
          _pressController.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _isPressed ? ColorsManager.kPrimaryColor.withOpacity(0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Hero(tag: 'icon_${widget.title}', child: Icon(widget.icon.icon, color: ColorsManager.kPrimaryColor)),
                const SizedBox(width: 12),
                Text(widget.title, style: const TextStyle(fontSize: 15, color: ColorsManager.dark)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: ColorsManager.kPrimaryColor, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
