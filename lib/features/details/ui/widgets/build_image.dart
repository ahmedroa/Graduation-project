import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/details.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BuildImagesCar extends StatelessWidget {
  const BuildImagesCar({super.key, required this.pageController, required this.widget});

  final PageController pageController;
  final Details widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.carList?.images.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                      index == (widget.carList?.images.length ?? 0) - 1
                          ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          : BorderRadius.zero,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 4), blurRadius: 8)],
                ),
                child: ClipRRect(
                  child: Image.network(
                    widget.carList?.images[index] ?? '',
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red));
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: BlocBuilder<DetailsCubit, DetailsState>(
              builder: (context, state) {
                return CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child:
                      state.isLikeLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                          : IconButton(
                            icon: Icon(
                              state.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: state.isLiked ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              if (widget.carList != null ) {
                              context.isNotLoggedIn ? notRegistered(context):  context.read<DetailsCubit>().toggleLike(widget.carList!);
                              
                              }
                            },
                          ),
                );
              },
            ),
          ),
          if (widget.carList?.images.length != null && widget.carList!.images.length > 1)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: SmoothPageIndicator(
                controller: pageController,
                count: widget.carList!.images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
