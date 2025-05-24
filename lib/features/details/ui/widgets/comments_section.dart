import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/details.dart';
class Comments extends StatelessWidget {
  const Comments({
    super.key,
    required TextEditingController commentController,
    required this.widget,
  }) : _commentController = commentController;

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
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'اكتب تعليقك هنا...',
                            border: InputBorder.none,
                            hintStyle: TextStyles.font14DarkRegular.copyWith(color: Colors.grey[600]),
                          ),
                          style: TextStyles.font14DarkRegular,
                          maxLines: null,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      horizontalSpace(8),
                      state.isAddingComment
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                            onPressed: () async {
                              if (_commentController.text.trim().isNotEmpty && widget.carList?.id != null) {
                                final success = await context.read<DetailsCubit>().addComment(
                                  widget.carList!.id!,
                                  _commentController.text,
                                );
                                if (success) {
                                  _commentController.clear();
                                  FocusScope.of(context).unfocus();
                                  await context.read<DetailsCubit>().getLastThreeComments(
                                    widget.carList!.id!,
                                  );
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
                  return Center(child: CircularProgressIndicator());
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
    
                // إذا كان هناك تعليقات، عرضها فقط بدون النص
                return Column(
                  children: [
                    // عرض آخر 3 تعليقات
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
                        return Center(child: CircularProgressIndicator());
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
        // صورة المستخدم
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
