import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/widgets/loading.dart';
import 'package:graduation/features/reported_cars/logic/cubit/reported_cars_cubit.dart';

class BuildItemReportedCars extends StatelessWidget {
  const BuildItemReportedCars({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
      builder: (context, state) {
        return state.whenOrNull(
              initial: () => loading(),
              loading: () => loading(),
              success:
                  (cars) => ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return ListTile(
                        leading:
                            car.image != null
                                ? Image.network(car.image!, width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.directions_car),
                        title: Text(car.name ?? "سيارة مجهولة"),
                        subtitle: Text(car.description ?? "لا يوجد وصف"),
                      );
                    },
                  ),
              error: (message) => Center(child: Text("خطأ: $message")),
            ) ??
            const Center(child: Text("لا توجد بيانات متاحة"));
      },
    );
  }
}


// class BuildItemReportedCars extends StatelessWidget {
//   const BuildItemReportedCars({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
//       builder: (context, state) {
//         return state.when(
//           initial: () => loading(),
//           loading: () => loading(),
//           success:
//               (carInformation) => ListView.builder(
//                 itemCount: carInformation.length,
//                 itemBuilder: (context, index) {
//                   final carList = carInformation[index];
//                   return BuildItemPostsCars(carList: carList);
//                 },
//               ),
//           error: (error) => Center(child: Text("❌ خطأ: $error")),
//         );
//       },
//     );
//   }
// }