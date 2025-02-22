import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';

import 'package:graduation/features/home/ui/screens/details.dart';

class BuildItemPostsCars extends StatelessWidget {
  final PostCar carList;
  const BuildItemPostsCars({super.key, required this.carList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Details(carList: carList)));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(carList.image ?? '', width: 100, height: 100, fit: BoxFit.cover),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carList.name ?? "اسم غير متوفر",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      Text(
                        carList.description ?? "وصف غير متوفر",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),

                      Text(carList.name ?? "اسم غير متوفر", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
