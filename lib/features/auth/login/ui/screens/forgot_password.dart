import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // دالة إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // العودة إلى شاشة تسجيل الدخول بعد 2 ثانية
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'لا يوجد حساب مسجل بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صحيح';
          break;
        case 'too-many-requests':
          errorMessage = 'تم إرسال طلبات كثيرة، حاول مرة أخرى لاحقاً';
          break;
        default:
          errorMessage = 'حدث خطأ: ${e.message}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red, duration: const Duration(seconds: 3)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 16),
                    SvgPicture.asset(ImgManager.logo, color: ColorsManager.kPrimaryColor, width: 50, height: 50),
                    const SizedBox(height: 10),
                    Text(
                      'إستعادة كلمة المرور',
                      style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                    verticalSpace(25),
                    Text('أدخل البريد الإلكتروني المسجل لإرسال رمز تحقق', style: TextStyles.font14GraySemiBold),
                    verticalSpace(25),
                    AppTextFormField(
                      controller: emailController,
                      hintText: 'البريدالإلكتروني المسجل',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }

                        return null;
                      },
                    ),
                    verticalSpace(60),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: MainButton(
                        text: isLoading ? 'جاري الإرسال...' : 'التالي',
                        onTap: sendPasswordResetEmail,
                        // child:
                        //     isLoading
                        //         ? const SizedBox(
                        //           height: 20,
                        //           width: 20,
                        //           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        //         )
                        // : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'هل تراجعت ؟ ', style: TextStyles.font13DarkBlueRegular),
                            TextSpan(
                              text: 'تسجيل الدخول',
                              style: TextStyles.font13BlueSemiBold,
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ForgotPassword extends StatelessWidget {
//   const ForgotPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).size.height / 16),
//                   SvgPicture.asset(ImgManager.logo, color: ColorsManager.kPrimaryColor, width: 50, height: 50),
//                   const SizedBox(height: 10),
//                   Text(
//                     'إستعادة كلمة المرور',
//                     style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
//                   ),
//                   verticalSpace(25),
//                   Text('أدخل البريد الإلكتروني المسجل لإرسال رمز تحقق', style: TextStyles.font14GraySemiBold),
//                   verticalSpace(25),
//                   AppTextFormField(
//             // controller: context.read<LogiCubit>().emailController,
//                     hintText: 'البريد الإلكتروني المسجل',
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   verticalSpace(60),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: MainButton(text: 'التالي', onTap: () {}),
//                   ),
//                   const SizedBox(height: 20),
//                   InkWell(
//                     onTap: () {
//                     },
//                     child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(text: 'هل تراجعت ؟ ', style: TextStyles.font13DarkBlueRegular),
//                           TextSpan(
//                             text: 'تسجيل الدخول',
//                             style: TextStyles.font13BlueSemiBold,
//                             recognizer: TapGestureRecognizer()..onTap = () {},
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
