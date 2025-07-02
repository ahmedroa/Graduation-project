import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/list.dart';

class ShowFilterDialog extends StatefulWidget {
  const ShowFilterDialog({super.key});

  @override
  State<ShowFilterDialog> createState() => _ShowFilterDialogState();
}

class _ShowFilterDialogState extends State<ShowFilterDialog> {
  String? selectedYear;
  String? selectedCity;
  String? selectedCarType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'تصفية النتائج',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsManager.kPrimaryColor),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorsManager.textFormField,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Theme.of(context).colorScheme.primaryContainer),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedYear,
                      hint: Text(
                        'موديل السيارة',
                        style: TextStyles.font14GrayRegular.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      style: TextStyles.font14GrayRegular.copyWith(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: InputBorder.none,
                      ),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 300,
                      isExpanded: true,
                      items:
                          CarData.generateCarModels(startYear: 1990, endYear: 2025) // إظهار جميع السنوات المتاحة
                          .map((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(
                                year,
                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue;
                        });
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorsManager.textFormField,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Theme.of(context).colorScheme.primaryContainer),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedCity,
                      hint: Text(
                        'المدينة',
                        style: TextStyles.font14GrayRegular.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: InputBorder.none,
                      ),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 300,
                      isExpanded: true,
                      items:
                          CarData.sudanCities.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(
                                city,
                                style: TextStyles.font14GrayRegular.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(12),
            // نوع السيارة
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: ColorsManager.textFormField,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Theme.of(context).colorScheme.primaryContainer),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedCarType,
                hint: Text(
                  'نوع السيارة',
                  style: TextStyles.font14GrayRegular.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                style: TextStyles.font14GrayRegular.copyWith(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: InputBorder.none,
                ),
                dropdownColor: Colors.white,
                menuMaxHeight: 300,
                isExpanded: true,
                items:
                    CarData.carTypes.map((String carType) {
                      return DropdownMenuItem<String>(
                        value: carType,
                        child: Text(
                          carType,
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCarType = newValue;
                  });
                },
                validator: (value) {
                  return null;
                },
              ),
            ),
            verticalSpace(12),
            MainButton(
              text: 'تطبيق الفلاتر',
              onTap: () {
                Navigator.pop(context, {'year': selectedYear, 'city': selectedCity, 'carType': selectedCarType});
              },
            ),
          ],
        ),
      ),
    );
  }
}
