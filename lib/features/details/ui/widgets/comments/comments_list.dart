import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/format_time_ago.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/widgets/comments/comments_section.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
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
                      formatTimeAgo(comment.timestamp!),
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

