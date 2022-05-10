import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/login_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read(loginViewModel.notifier);
    //viewModel.addUser();
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      body: loginViewBody(viewModel),
    );
  }

  Widget loginViewBody(LoginViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 100,
        ),
        Expanded(
          flex: 1,
          child: Container(
            // padding: EdgeInsets.all(10.h),
            child: Lottie.asset('assets/animations/login_animation.json'),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding:
                const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextField("Enter Username", false, false, false,
                    viewModel.userNameStateProvider),
                const SizedBox(height: 20),
                CustomTextField("Enter Password", true, true, true,
                    viewModel.passwordStateProvider),
                const SizedBox(height: 20),

                Consumer(
                  builder: (context, watch, child) {
                    AsyncValue loginState = watch(viewModel.loginStateProvider).state;
                    return loginState.when(data: (dynamic value) {
                      return loginButton(viewModel);
                    }, error: (Object error, StackTrace? stackTrace) {
                      return loginButton(viewModel);
                    }, loading: () {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SizedBox loginButton(LoginViewModel viewModel) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Login"),
        onPressed: () {
          viewModel.login();
        },
      ),
    );
  }
}
