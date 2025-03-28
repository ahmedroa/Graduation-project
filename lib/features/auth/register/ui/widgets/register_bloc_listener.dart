import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener;
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/loading.dart';
import 'package:graduation/features/auth/register/cubit/register_cubit.dart';

class RegisterBlocListener extends StatelessWidget {
  const RegisterBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            loading();
          },
          success: () {
            Navigator.pop(context);
            context.pushNamed(Routes.bottomNavBar);
          },
          error: (error) {
            print('error: $error');
            setupErrorState(context, error);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}

void setupErrorState(BuildContext context, String errorMessage) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red, size: 32),
          content: Text(errorMessage, style: TextStyles.font15DarkBlueMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Got it', style: TextStyles.font15DarkBlueMedium),
            ),
          ],
        ),
  );
}
