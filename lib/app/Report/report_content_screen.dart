import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';

// 2. Report Content Screen
class ReportContentScreen extends StatefulWidget {
  final String contentId;
  final String reportedUserId;

  const ReportContentScreen({
    super.key,
    required this.contentId,
    required this.reportedUserId,
  });

  @override
  State<ReportContentScreen> createState() => _ReportContentScreenState();
}
class _ReportContentScreenState extends State<ReportContentScreen> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool _blockUserChecked = false;
  bool _isSubmitting = false;

  final List<String> _reportReasons = [
    'محتوى مسيء أو غير لائق',
    'محتوى عنصري أو كراهية',
    'تهديدات أو تحرش',
    'محتوى مزيف أو خادع',
    'سبام أو إعلانات مضللة',
    'انتهاك حقوق الملكية',
    'محتوى جنسي غير لائق',
    'أخرى',
  ];

  Future<void> _submitReport() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول للإبلاغ')),
      );
      return;
    }

    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار سبب البلاغ')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final reportData = {
      'reportedBy': currentUser.uid,
      'reportedUser': widget.reportedUserId,
      'contentId': widget.contentId,
      'reason': _selectedReason,
      'details': _detailsController.text.trim(),
      'blocked': _blockUserChecked,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('reports').add(reportData);

      if (_blockUserChecked) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('blockedUsers')
            .doc(widget.reportedUserId)
            .set({'blockedAt': FieldValue.serverTimestamp()});
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال البلاغ بنجاح')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإبلاغ عن محتوى')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'لماذا تريد الإبلاغ عن هذا المحتوى؟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _reportReasons.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(
                      _reportReasons[index],
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    value: _reportReasons[index],
                    groupValue: _selectedReason,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedReason = value;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              controller: _detailsController,
              maxLines: 3,
              hintText: 'يمكنك إضافة تفاصيل أكثر هنا...',
              helperText: 'تفاصيل إضافية (اختياري)',
              validator: (v) => null,
            ),
            CheckboxListTile(
              value: _blockUserChecked,
              onChanged: (value) {
                setState(() {
                  _blockUserChecked = value ?? false;
                });
              },
              title: const Text(
                'حظر المستخدم',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            /// زر الإرسال مع لودنق
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : MainButton(text: 'إرسال البلاغ', onTap: _submitReport),

            verticalSpace(30),
          ],
        ),
      ),
    );
  }
}
