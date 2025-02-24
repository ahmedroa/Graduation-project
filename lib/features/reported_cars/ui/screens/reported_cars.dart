import 'package:flutter/material.dart';
import 'package:graduation/features/reported_cars/ui/widgets/build_item_reported_cars.dart';

class ReportedCars extends StatelessWidget {
  const ReportedCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reported Cars'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // context.read<ReportedCarsCubit>().getReportedCars();
            },
          ),
        ],
      ),
      body: BuildItemReportedCars(),
    );
  }
}
