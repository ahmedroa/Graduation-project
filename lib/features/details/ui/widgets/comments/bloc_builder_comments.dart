import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/details.dart';
import 'package:graduation/features/details/ui/widgets/comments/comments_list.dart';
import 'package:graduation/features/details/ui/widgets/comments/comments_section.dart';

class BlocBuilderComments extends StatelessWidget {
  const BlocBuilderComments({super.key, required this.widget});

  final Details widget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        if (state.isCommentsLoading) {
          return commentsShimmerList(itemCount: 3, context: context);
        }

        if (state.lastThreeComments.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'لا توجد تعليقات بعد\nكن أول من يعلق!',
                style: TextStyles.font14DarkRegular,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: [
            ...state.lastThreeComments.map((comment) => commentWidget(comment)),

            // زر عرض المزيد
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: () {
                  showAllCommentsBottomSheet(context: context, carList: widget.carList!);
                },
                child: Text(
                  'عرض المزيد من التعليقات',
                  style: TextStyle(color: ColorsManager.kPrimaryColor, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


// عرض جميع التعليقات في bottom sheet
void showAllCommentsBottomSheet({required BuildContext context, required PostCar? carList}) {
  context.read<DetailsCubit>().getAllComments(carList!.id!);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => BlocProvider(
          create: (context) => DetailsCubit()..getAllComments(carList.id!),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    children: [
                      Text('جميع التعليقات', style: TextStyles.font16DarkBold),
                      Spacer(),
                      IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                    ],
                  ),
                ),

                // قائمة التعليقات
                CommentsList(),
              ],
            ),
          ),
        ),
  );
}

