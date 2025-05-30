import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/details.dart';
import 'package:graduation/features/details/ui/widgets/comments/bloc_builder_comments.dart';
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
                              if (context.isNotLoggedIn) {
                                notRegistered(context);
                                return;
                              }

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

            BlocBuilderComments(widget: widget),
          ],
        ),
      ),
    );
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
          CircleAvatar(radius: 16, backgroundColor: Colors.grey[300]),

          horizontalSpace(8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                    Spacer(),
                    Container(
                      height: 12,
                      width: 50,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                ),

                verticalSpace(4),

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

Widget commentsShimmerList({int itemCount = 3, context}) {
  return Column(children: List.generate(itemCount, (index) => commentShimmerWidget(context)));
}
