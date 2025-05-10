import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/reported_cars/ui/widgets/bloc_builder_reported_cars.dart';

class ReportedCars extends StatelessWidget {
  const ReportedCars({super.key});

  @override
  Widget build(BuildContext context) {
    int x = DateTime.now().millisecondsSinceEpoch;
    print(x);
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(backgroundColor: Colors.white, title: Text(' السيارات المبلغ عنها'), centerTitle: true,

      ),
      body: BlocBuildereportedCars(),
    );
  }
}
