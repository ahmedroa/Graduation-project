


  // class BuildItemReportedCars extends StatefulWidget {
  //   const BuildItemReportedCars({super.key});

  //   @override
  //   State<BuildItemReportedCars> createState() => _BuildItemReportedCarsState();
  // }

  // class _BuildItemReportedCarsState extends State<BuildItemReportedCars> {
  //   final RefreshController _refreshController = RefreshController();

  //   void _onRefresh() async {
  //     context.read<ReportedCarsCubit>().getReportedCars();
  //     _refreshController.refreshCompleted();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
  //       builder: (context, state) {
  //         return state.whenOrNull(
  //               initial: () => const Center(child: CircularProgressIndicator()),
  //               loading: () => const Center(child: CircularProgressIndicator()),
  //               success:
  //                   (cars) => SmartRefresher(
  //                     controller: _refreshController,
  //                     onRefresh: _onRefresh,
  //                     header: CustomHeader(
  //                       builder: (context, mode) {
  //                         String text = "";
  //                         IconData icon = Icons.refresh;
  //                         Color iconColor = Colors.grey;

  //                         if (mode == RefreshStatus.idle) {
  //                           text = "اسحب للتحديث";
  //                           icon = Icons.arrow_downward;
  //                           iconColor = Colors.grey;
  //                         } else if (mode == RefreshStatus.canRefresh) {
  //                           text = "اترك للإفلات والتحديث";
  //                           icon = Icons.refresh;
  //                           iconColor = Colors.blue;
  //                         } else if (mode == RefreshStatus.refreshing) {
  //                           text = "جاري التحديث...";
  //                           icon = Icons.refresh;
  //                           iconColor = Colors.blue;
  //                         } else if (mode == RefreshStatus.completed) {
  //                           text = "تم التحديث بنجاح";
  //                           icon = Icons.check_circle;
  //                           iconColor = Colors.green;
  //                         }

  //                         return refreshStatus(mode, iconColor, icon, text);
  //                       },
  //                     ),
  //                     child:
  //                         cars.isEmpty
  //                             ? NoDataWidget()
  //                             : ListView.builder(
  //                               itemCount: cars.length,
  //                               itemBuilder: (context, index) {
  //                                 final car = cars[index];
  //                                 return Padding(
  //                                   padding: const EdgeInsets.all(12.0),
  //                                   child: Container(
  //                                     width: double.infinity,
  //                                     height: 160,
  //                                     decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       borderRadius: BorderRadius.circular(16),
  //                                       boxShadow: [
  //                                         BoxShadow(
  //                                           color: Colors.grey.withOpacity(0.2),
  //                                           blurRadius: 6,
  //                                           offset: const Offset(0, 2),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(12.0),
  //                                       child: Row(
  //                                         children: [
  //                                           ClipRRect(
  //                                             borderRadius: BorderRadius.circular(8),
  //                                             child:
  //                                                 car.image != null && car.image!.isNotEmpty
  //                                                     ? Image.network(
  //                                                       car.image!,
  //                                                       width: 120,
  //                                                       height: 120,
  //                                                       fit: BoxFit.cover,
  //                                                       errorBuilder:
  //                                                           (context, error, stackTrace) => Container(
  //                                                             width: 120,
  //                                                             height: 120,
  //                                                             color: Colors.grey.shade200,
  //                                                             child: const Icon(
  //                                                               Icons.broken_image,
  //                                                               size: 50,
  //                                                               color: Colors.grey,
  //                                                             ),
  //                                                           ),
  //                                                     )
  //                                                     : Container(
  //                                                       width: 120,
  //                                                       height: 120,
  //                                                       color: Colors.grey.shade200,
  //                                                       child: const Icon(
  //                                                         Icons.directions_car,
  //                                                         size: 50,
  //                                                         color: Colors.grey,
  //                                                       ),
  //                                                     ),
  //                                           ),
  //                                           const SizedBox(width: 16),
  //                                           Expanded(
  //                                             child: Column(
  //                                               crossAxisAlignment: CrossAxisAlignment.start,
  //                                               mainAxisAlignment: MainAxisAlignment.start,
  //                                               children: [
  //                                                 Row(
  //                                                   children: [
  //                                                     Text(
  //                                                       // car.name ??
  //                                                       "سيارة غير معروفة",
  //                                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                                                       maxLines: 1,
  //                                                       overflow: TextOverflow.ellipsis,
  //                                                     ),
  //                                                     Spacer(),

  //                                                     Text(
  //                                                       car.timestamp ?? "سيارة غير معروفة",
  //                                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                                                       maxLines: 1,
  //                                                       overflow: TextOverflow.ellipsis,
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                                 if (car.model != null)
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(top: 4),
  //                                                     child: Text(
  //                                                       "رقم اللوحة: ${car.plateNumber}",
  //                                                       style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
  //                                                     ),
  //                                                   ),
  //                                                 if (car.color != null)
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(top: 4),
  //                                                     child: Text(
  //                                                       "اللون: ${car.color}",
  //                                                       style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
  //                                                     ),
  //                                                   ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                   ),
  //               error: (message) => errorWidget(message, context),
  //             ) ??
  //             const Center(child: Text("لا توجد بيانات متاحة"));
  //       },
  //     );
  //   }

// class BuildItemReportedCars extends StatefulWidget {
//   const BuildItemReportedCars({super.key});

//   @override
//   State<BuildItemReportedCars> createState() => _BuildItemReportedCarsState();
// }

// class _BuildItemReportedCarsState extends State<BuildItemReportedCars> {
//   final RefreshController _refreshController = RefreshController();

//   void _onRefresh() async {
//     context.read<ReportedCarsCubit>().getReportedCars();
//     _refreshController.refreshCompleted();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
//       builder: (context, state) {
//         return state.whenOrNull(
//               initial: () => const Center(child: CircularProgressIndicator()),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               success:
//                   (cars) => SmartRefresher(
//                     controller: _refreshController,
//                     onRefresh: _onRefresh,
//                     header: CustomHeader(
//                       builder: (context, mode) {
//                         String text = "";

//                         if (mode == RefreshStatus.idle) {
//                           text = "اسحب للتحديث";
//                         } else if (mode == RefreshStatus.canRefresh) {
//                           text = "اترك للإفلات والتحديث";
//                         } else if (mode == RefreshStatus.refreshing) {
//                           text = "جاري التحديث...";
//                         } else if (mode == RefreshStatus.completed) {
//                           text = "تم التحديث بنجاح";
//                         }
//                         return Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(text, style: const TextStyle(fontSize: 16)),
//                           ),
//                         );
//                       },
//                     ),
//                     child: ListView.builder(
//                       itemCount: cars.length,
//                       itemBuilder: (context, index) {
//                         final car = cars[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Container(
//                             width: double.infinity,
//                             height: 160,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Row(
//                                 children: [
//                                   car.image != null
//                                       ? Image.network(car.image!, width: 120, height: 120, fit: BoxFit.cover)
//                                       : const Icon(Icons.directions_car, size: 50),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       car.name ?? "سيارة غير معروفة",
//                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               error: (message) => Center(child: Text("حدث خطأ: $message")),
//             ) ??
//             const Center(child: Text("لا توجد بيانات متاحة"));
//       },
//     );
//   }
// }

// class BuildItemReportedCars extends StatefulWidget {
//   const BuildItemReportedCars({super.key});

//   @override
//   State<BuildItemReportedCars> createState() => _BuildItemReportedCarsState();
// }

// class _BuildItemReportedCarsState extends State<BuildItemReportedCars> {
//   final RefreshController _refreshController = RefreshController();

//   // void _onRefresh() async {
//   //   // استدعِ الدالة التي تجلب السيارات المبلغ عنها
//   //   context.read<ReportedCarsCubit>().getReportedCars();

//   //   // أوقف مؤثر التحميل
//   //   _refreshController.refreshCompleted();
//   // }
//   void _onRefresh() async {
//     context.read<ReportedCarsCubit>().getReportedCars();
//     _refreshController.refreshCompleted();

//     // عرض رسالة "تم التحديث"
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("تم التحديث بنجاح"), duration: Duration(seconds: 2)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
//       builder: (context, state) {
//         return state.whenOrNull(
//               initial: () => loading(),
//               loading: () => loading(),
//               success:
//                   (cars) => SmartRefresher(
//                     controller: _refreshController,
//                     onRefresh: _onRefresh,
//                     header: const WaterDropHeader(),
//                     child: ListView.builder(
//                       itemCount: cars.length,
//                       itemBuilder: (context, index) {
//                         final car = cars[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Container(
//                             width: double.infinity,
//                             height: 160,
//                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Row(
//                                 children: [
//                                   // car.image != null
//                                   //     ? Image.network(car.image!, width: 120, height: 120, fit: BoxFit.cover)
//                                   //     : const Icon(Icons.directions_car),
//                                   car.image != null
//                                       ? Image.network(car.image!, width: 120, height: 120, fit: BoxFit.cover)
//                                       : const Icon(Icons.directions_car),
//                                   horizontalSpace(16),
//                                   Column(
//                                     children: [Text(car.name ?? "سيارة مجهولة", style: TextStyles.font16DarkBold)],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               error: (message) => Center(child: Text("خطأ: $message")),
//             ) ??
//             const Center(child: Text("لا توجد بيانات متاحة"));
//       },
//     );
//   }
// }

// class BuildItemReportedCars extends StatelessWidget {
//   const BuildItemReportedCars({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReportedCarsCubit, ReportedCarsState>(
//       builder: (context, state) {
//         return state.whenOrNull(
//               initial: () => loading(),
//               loading: () => loading(),
//               success:
//                   (cars) => ListView.builder(
//                     itemCount: cars.length,
//                     itemBuilder: (context, index) {
//                       final car = cars[index];
//                       // return ListTile(
//                       // leading:
//                       // car.image != null
//                       //     ? Image.network(car.image!, width: 50, height: 50, fit: BoxFit.cover)
//                       //     : const Icon(Icons.directions_car),
//                       //   title: Text(car.name ?? "سيارة مجهولة"),
//                       //   subtitle: Text(car.description ?? "لا يوجد وصف"),
//                       // );
//                       return Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Container(
//                           width: double.infinity,
//                           height: 160,
//                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               children: [
//                                 car.image != null
//                                     ? Image.network(car.image!, width: 120, height: 120, fit: BoxFit.cover)
//                                     : const Icon(Icons.directions_car),
//                                 horizontalSpace(16),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       // car.name ??
//                                       "سيارة مجهولة",
//                                       style: TextStyles.font16DarkBold,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//               error: (message) => Center(child: Text("خطأ: $message")),
//             ) ??
//             const Center(child: Text("لا توجد بيانات متاحة"));
//       },
//     );
//   }
// }
