import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/ui/widgets/show_filter_dialog.dart';

class BuildSearchField extends StatelessWidget {
  const BuildSearchField({super.key, required this.context, required FocusNode searchFocusNode})
    : _searchFocusNode = searchFocusNode;

  final BuildContext context;
  final FocusNode _searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<HomeCubit>().startSearch();
                _searchFocusNode.requestFocus();
              },
              child: AbsorbPointer(
                child: AppTextFormField(
                  hintText: 'بحث',
                  validator: (value) {
                    return null;
                  },
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: ColorsManager.kPrimaryColor),
                ),
              ),
            ),
          ),
          // horizontalSpace(12),
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(color: ColorsManager.kPrimaryColor, borderRadius: BorderRadius.circular(10)),
          //   child: IconButton(
          //     icon: const Icon(Icons.filter_list, color: Colors.white),
          //     onPressed: () {
          //       showModalBottomSheet(
          //         context: context,
          //         isScrollControlled: true,
          //         builder: (context) => ShowFilterDialog(),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
