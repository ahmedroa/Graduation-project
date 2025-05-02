import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/ui/screens/details.dart';

class BuildItemPostsCars extends StatelessWidget {
  final PostCar carList;
  const BuildItemPostsCars({super.key, required this.carList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // انتقال مع أنيميشن
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      BlocProvider(create: (context) => HomeCubit(), child: Details(carList: carList)),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var curve = Curves.easeInOut;
                var curveTween = CurveTween(curve: curve);

                var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation.drive(curveTween));

                return FadeTransition(opacity: fadeAnimation, child: child);
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: .1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة السيارة
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Image.network(
                  carList.image ?? '',
                  width: double.infinity,
                  height: 145,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 140,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          carList.name ?? "اسم غير متوفر",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        carList.stolen == true
                            ? Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffFF4D4D).withOpacity(0.16),
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text("مفقود", style: TextStyle(fontSize: 16, color: Color(0xffFF4D4D))),
                              ),
                            )
                            : Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff0070D1).withOpacity(0.16),
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text("موجود", style: TextStyle(fontSize: 16, color: Color(0xff0070D1))),
                              ),
                            ),
                      ],
                    ),
                    Text(
                      carList.description ?? "وصف غير متوفر",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    verticalSpace(4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: ColorsManager.kPrimaryColor),
                        SizedBox(width: 4),
                        Text(carList.city ?? '', style: TextStyle(fontSize: 12)),
                        Text(' - ', style: TextStyle(fontSize: 12)),
                        Text(carList.neighborhood ?? '', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    verticalSpace(4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
