import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';

class BuildItemReportedCars extends StatelessWidget {
  const BuildItemReportedCars({super.key, required this.car, required this.timeAgoText});

  final PostCar car;
  final String timeAgoText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    car.image != null && car.image!.isNotEmpty
                        ? Image.network(
                          car.image!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                        )
                        : Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.directions_car, size: 50, color: Colors.grey),
                        ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          car.name ?? "سيارة غير معروفة",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            // Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                            SizedBox(width: 4),
                            Text(
                              timeAgoText,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (car.model != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "رقم اللوحة: ${car.plateNumber}",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        ),
                      ),
                    if (car.color != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("اللون: ${car.color}", style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                      ),
                    verticalSpace(12),
                    car.stolen == true
                        ? Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFF4D4D).withOpacity(0.16),
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text("مفقودة", style: TextStyle(fontSize: 16, color: Color(0xffFF4D4D))),
                          ),
                        )
                        : Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff0070D1).withOpacity(0.16),
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text("موجوده", style: TextStyle(fontSize: 16, color: Color(0xff0070D1))),
                          ),
                        ),
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
