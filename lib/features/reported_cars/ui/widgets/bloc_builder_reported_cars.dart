import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/date_time_extension.dart';
import 'package:graduation/features/reported_cars/logic/cubit/reported_cars_cubit.dart';
import 'package:graduation/features/reported_cars/ui/widgets/build_item_reported_cars.dart';
import 'package:graduation/features/reported_cars/ui/widgets/no_data_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BlocBuildereportedCars extends StatefulWidget {
  const BlocBuildereportedCars({super.key});

  @override
  State<BlocBuildereportedCars> createState() => _BlocBuildereportedCarsState();
}

class _BlocBuildereportedCarsState extends State<BlocBuildereportedCars> {
  final RefreshController _refreshController = RefreshController();
   void _onRefresh() async {
    context.read<ReportedCarsCubit>().getReportedCars();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
      builder: (context, state) {
        return state.whenOrNull(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              success:
                  (cars) => SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    header: CustomHeader(
                      builder: (context, mode) {
                        String text = "";
                        IconData icon = Icons.refresh;
                        Color iconColor = Colors.grey;

                        if (mode == RefreshStatus.idle) {
                          text = "اسحب للتحديث";
                          icon = Icons.arrow_downward;
                          iconColor = Colors.grey;
                        } else if (mode == RefreshStatus.canRefresh) {
                          text = "اترك للإفلات والتحديث";
                          icon = Icons.refresh;
                          iconColor = Colors.grey;
                        } else if (mode == RefreshStatus.refreshing) {
                          text = "جاري التحديث...";
                          icon = Icons.refresh;
                          iconColor = Colors.grey;
                        } else if (mode == RefreshStatus.completed) {
                          text = "تم التحديث بنجاح";
                          icon = Icons.check_circle;
                          iconColor = Colors.green;
                        }
                        return refreshStatus(mode, iconColor, icon, text);
                      },
                    ),
                    child:
                        cars.isEmpty
                            ? NoDataWidget()
                            : ListView.builder(
                              itemCount: cars.length,
                              itemBuilder: (context, index) {
                                final car = cars[index];
                                String timeAgoText = "";
                                if (car.timestamp != null) {
                                  try {
                                    int timestamp = int.parse(car.timestamp!);
                                    timeAgoText = timestamp.getTimeAgo();
                                  } catch (e) {
                                    timeAgoText = car.timestamp!;
                                  }
                                }

                                return BuildItemReportedCars(car: car, timeAgoText: timeAgoText);
                              },
                            ),
                  ),
              error: (message) => errorWidget(message, context),
            ) ??
            const Center(child: Text("لا توجد بيانات متاحة"));
      },
    );
  }

  Center refreshStatus(RefreshStatus? mode, Color iconColor, IconData icon, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mode == RefreshStatus.refreshing
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  ),
                )
                : Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 16, color: iconColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Center errorWidget(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            "حدث خطأ: $message",
            style: TextStyle(fontSize: 16, color: Colors.red.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<ReportedCarsCubit>().getReportedCars(),
            icon: const Icon(Icons.refresh),
            label: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}