import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/car_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/car_owner_information.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/location_information.dart';

class Section extends StatelessWidget {
  const Section({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('معلومات البلاغ')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(10),
            BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                return Text(
                  '${postsCubit.selectedOption} من 3 مراحل لإنهاء نشر معلومات سيارتك',
                  style: TextStyles.font10GreyRegular,
                );
              },
            ),
            verticalSpace(10),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) {
                        final option = index + 1;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => postsCubit.selectOption(option),
                            child: BlocBuilder<PostsCubit, PostsState>(
                              builder: (context, state) {
                                final isSelected = postsCubit.selectedOption == option;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 5),
                                  child: Column(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: isSelected ? ColorsManager.kPrimaryColor : const Color(0xffA2A2A2),
                                              width: 4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        option == 1
                                            ? 'معلومات السياره'
                                            : option == 2
                                            ? 'معلومات الموقع'
                                            : 'معلومات التواصل',
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Theme.of(context).colorScheme.secondary
                                                  : const Color(0xffA2A2A2),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    verticalSpace(12),
                    BlocBuilder<PostsCubit, PostsState>(
                      builder: (context, state) {
                        switch (postsCubit.selectedOption) {
                          case 1:
                            return CarInformation();
                          case 2:
                            return LocationInformation();
                          case 3:
                            return CarOwnerInformation();
                          default:
                            return CarOwnerInformation();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
