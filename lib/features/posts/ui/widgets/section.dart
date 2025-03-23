import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/screens/car_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Section extends StatelessWidget {
  const Section({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>(); // جلب الـ Cubit

    return Scaffold(
      appBar: AppBar(title: const Text('معلومات السكن')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(10),
            BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                return Text(
                  '${postsCubit.selectedOption} من 3 مراحل لإنهاء اول خطوة في إعلان وحدتك السكنية',
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
                            onTap: () => postsCubit.selectOption(option), // تحديث الـ Cubit عند الضغط
                            child: BlocBuilder<PostsCubit, PostsState>(
                              builder: (context, state) {
                                final isSelected = postsCubit.selectedOption == option;
                                return Column(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isSelected
                                                ? ColorsManager.kPrimaryColor
                                                : const Color(0xffA2A2A2),
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
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.secondary
                                            : const Color(0xffA2A2A2),
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
                          case 3:
                            return Container(); // استبدلها بويدجت المعلومة المناسبة
                          default:
                            return Container();
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
// class Section extends StatefulWidget {
//   const Section({super.key});

//   @override
//   State<Section> createState() => _SectionState();
// }

// class _SectionState extends State<Section> {
//   int _selectedOption = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('معلومات السكن')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             verticalSpace(10),
//             Text(
//               '$_selectedOption من 3 مراحل لإنهاء اول خطوة في إعلان وحدتك السكنية',
//               style: TextStyles.font10GreyRegular,
//             ),
//             verticalSpace(10),
//             Expanded(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _selectedOption = 1;
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   curve: Curves.easeInOut,
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color:
//                                             _selectedOption == 1
//                                                 ? ColorsManager.kPrimaryColor
//                                                 : const Color(0xffA2A2A2),
//                                         width: _selectedOption == 1 ? 4 : 4,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       'معلومات السياره',
//                                       style:
//                                           _selectedOption == 1
//                                               ? TextStyle(
//                                                 color: Theme.of(context).colorScheme.secondary,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12,
//                                               )
//                                               : const TextStyle(fontSize: 12, color: Color(0xffA2A2A2)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         horizontalSpace(15),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _selectedOption = 2;
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   curve: Curves.easeInOut,
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color:
//                                             _selectedOption == 2
//                                                 ? ColorsManager.kPrimaryColor
//                                                 : const Color(0xffA2A2A2),
//                                         width: _selectedOption == 2 ? 4 : 4,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       'معلومات الموقع',
//                                       style:
//                                           _selectedOption == 2
//                                               ? TextStyle(
//                                                 color: Theme.of(context).colorScheme.secondary,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12,
//                                               )
//                                               : const TextStyle(fontSize: 12, color: Color(0xffA2A2A2)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         horizontalSpace(15),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _selectedOption = 3;
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   curve: Curves.easeInOut,
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                         color:
//                                             _selectedOption == 3
//                                                 ? ColorsManager.kPrimaryColor
//                                                 : const Color(0xffA2A2A2),
//                                         width: _selectedOption == 3 ? 4 : 4,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       'معلومات التواصل',
//                                       style:
//                                           _selectedOption == 3
//                                               ? TextStyle(
//                                                 color: Theme.of(context).colorScheme.secondary,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12,
//                                               )
//                                               : const TextStyle(fontSize: 12, color: Color(0xffA2A2A2)),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // horizontalSpace(15),
//                       ],
//                     ),
//                     verticalSpace(12),
//                     _selectedOption == 1
//                         ? CarInformation()
//                         : _selectedOption == 2
//                         ? Container()
//                         : _selectedOption == 3
//                         ? Container()
//                         : Container(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
