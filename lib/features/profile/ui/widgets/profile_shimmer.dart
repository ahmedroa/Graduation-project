
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildShimmerField()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildShimmerField()),
                  ],
                ),
                const SizedBox(height: 12),
                // حقل الإيميل
                _buildShimmerField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerField() {
    return Container(
      height: 54, // تقريباً نفس ارتفاع حقل AppTextFormField
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
      ),
    );
  }
}
