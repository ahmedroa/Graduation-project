import 'package:flutter/material.dart';

void showSelectionSheet(BuildContext context, List<String> items, TextEditingController controller, String title) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      controller.text = items[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
