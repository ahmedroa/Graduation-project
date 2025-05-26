import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/details.dart';
import 'package:shimmer/shimmer.dart';

class Comments extends StatelessWidget {
  const Comments({super.key, required TextEditingController commentController, required this.widget})
    : _commentController = commentController;

  final TextEditingController _commentController;
  final Details widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التعليقات', style: TextStyles.font16DarkBold),
            verticalSpace(16),

            BlocBuilder<DetailsCubit, DetailsState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'اكتب تعليقك هنا...',
                            border: InputBorder.none,
                            hintStyle: TextStyles.font14DarkRegular.copyWith(color: Colors.grey[600]),
                          ),
                          style: TextStyles.font14DarkRegular,
                          maxLines: null,
                          textAlign: TextAlign.right,
                          controller: _commentController,
                        ),
                      ),
                      horizontalSpace(8),
                      state.isAddingComment
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                            onPressed: () async {
                              print('object');
                              print('object');
                              print(widget.carList?.id);
                              if (_commentController.text.trim().isNotEmpty && widget.carList?.id != null) {
                                final success = await context.read<DetailsCubit>().addComment(
                                  widget.carList!.id!,
                                  _commentController.text,
                                );
                                if (success) {
                                  _commentController.clear();
                                  FocusScope.of(context).unfocus();
                                  await context.read<DetailsCubit>().getLastThreeComments(widget.carList!.id!);
                                }
                              }
                            },
                            icon: Icon(Icons.send, color: ColorsManager.kPrimaryColor),
                          ),
                    ],
                  ),
                );
              },
            ),
            verticalSpace(16),

            BlocBuilder<DetailsCubit, DetailsState>(
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
            ),
          ],
        ),
      ),
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
                Expanded(
                  child: BlocBuilder<DetailsCubit, DetailsState>(
                    builder: (context, state) {
                      if (state.isCommentsLoading) {
                        return commentsShimmerList(itemCount: 3, context: context);
                      }

                      if (state.allComments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.comment_outlined, size: 64, color: Colors.grey[400]),
                              verticalSpace(16),
                              Text(
                                'لا توجد تعليقات بعد',
                                style: TextStyles.font16DarkBold.copyWith(color: Colors.grey[600]),
                              ),
                              verticalSpace(8),
                              Text(
                                'كن أول من يعلق على هذه السيارة!',
                                style: TextStyles.font14DarkRegular.copyWith(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: state.allComments.length,
                        itemBuilder: (context, index) {
                          return commentWidget(state.allComments[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

Widget commentWidget(Comment comment) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: ColorsManager.kPrimaryColor,
          backgroundImage: comment.userProfileImage != null ? NetworkImage(comment.userProfileImage!) : null,
          child:
              comment.userProfileImage == null
                  ? Text(
                    comment.userName.isNotEmpty ? comment.userName[0] : 'م',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                  : null,
        ),
        horizontalSpace(8),

        // محتوى التعليق
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.userName, style: TextStyles.font14DarkMedium),
                  Spacer(),
                  if (comment.timestamp != null)
                    Text(
                      _formatTimeAgo(comment.timestamp!),
                      // style: TextStyles.font12DarkRegular.copyWith(color: Colors.grey[600]),
                    ),
                ],
              ),
              verticalSpace(4),
              Text(comment.comment, style: TextStyles.font14DarkRegular),
            ],
          ),
        ),
      ],
    ),
  );
}

String _formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return 'منذ ${difference.inDays} يوم';
  } else if (difference.inHours > 0) {
    return 'منذ ${difference.inHours} ساعة';
  } else if (difference.inMinutes > 0) {
    return 'منذ ${difference.inMinutes} دقيقة';
  } else {
    return 'الآن';
  }
}

Widget commentShimmerWidget(context) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar shimmer
          CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),

          horizontalSpace(8),

          // محتوى التعليق
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // اسم المستخدم
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                    Spacer(),
                    // الوقت
                    Container(
                      height: 12,
                      width: 50,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                ),

                verticalSpace(4),

                // نص التعليق - عدة أسطر
                Column(
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                    verticalSpace(4),
                    Container(
                      height: 14,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// لعرض عدة shimmer comments
Widget commentsShimmerList({int itemCount = 3, context}) {
  return Column(children: List.generate(itemCount, (index) => commentShimmerWidget(context)));
}
