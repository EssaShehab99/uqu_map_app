import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/my_profile_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Profile",MyProfileViewBody());

  }
}

class MyProfileViewBody extends StatelessWidget {
  const MyProfileViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read(myProfileViewModel.notifier);
    viewModel.getLoggedUser();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            child: ListView(
              children: [
                AppStyles.textFieldTitleText('First Name'),
                const SizedBox(height: 10),
                CustomTextField(
                    "", false, false, false, viewModel.firstNameStateProvider),
                const SizedBox(height: 10),
                AppStyles.textFieldTitleText('Last Name'),
                const SizedBox(height: 10),
                CustomTextField("", false, false, false,
                    viewModel.lastNameStateProvider),
                const SizedBox(height: 10),
                AppStyles.textFieldTitleText('Email'),
                const SizedBox(height: 10),
                CustomTextField("", false, false, false,
                    viewModel.emailStateProvider),
                const SizedBox(height: 10),
                AppStyles.textFieldTitleText('Password'),
                const SizedBox(height: 10),
                CustomTextField("", true, true, true,
                    viewModel.passwordStateProvider),

                const SizedBox(height: 20),

                 Consumer(
                  builder: (context, watch, child) {
                    AsyncValue loginState = watch(viewModel.updateProfileStateProvider).state;
                    return loginState.when(data: (dynamic value) {
                      return updateProfileButton(viewModel);
                    }, error: (Object error, StackTrace? stackTrace) {
                      return updateProfileButton(viewModel);
                    }, loading: () {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
                        ),
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

 SizedBox updateProfileButton(MyProfileViewModel viewModel) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Update Profile"),
        onPressed: () {
          viewModel.updateProfile();
        },
      ),
    );
  }

}
