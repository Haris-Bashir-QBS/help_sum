import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/clickable_text_pair.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is SignupSuccess) {
        context.goNamed(
          AppRoutes.verifyOtp,
          extra: {'userId': next.userId, 'phone': _phoneController.text},
        );
        ref.read(authNotifierProvider.notifier).reset();
      }

      if (next is SignupError) {
        CustomToast.errorToast(context: context, message: next.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final AuthState authState = ref.watch(authNotifierProvider);
    final isLoading = authState is SignupLoading;
    return ModalProgressHUD(
      inAsyncCall: isLoading,

      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  140.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 0,
                    child: _buildIllustration(),
                  ),
                  40.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 100,
                    child: _buildCreateAccountTitle(),
                  ),
                  32.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 200,
                    child: _buildFullNameTextField(),
                  ),
                  15.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 300,
                    child: _buildPhoneNumberTextField(),
                  ),
                  15.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 400,
                    child: _buildPasswordTextField(),
                  ),
                  15.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 500,
                    child: _buildConfirmPasswordTextField(),
                  ),
                  30.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 600,
                    child: _buildSignUpButton(),
                  ),
                  26.verticalSpace,
                  AnimatedSlideFade(
                    delayMilliseconds: 700,
                    child: _buildLoginText(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return GestureDetector(
      onTap: _fillMockDetails,
      child: Image.asset(AppAssets.authIllustrationIcon, height: 200.h),
    );
  }

  Widget _buildCreateAccountTitle() {
    return CustomText(
      text: AppTexts.createAccountTitle,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildFullNameTextField() {
    return CustomTextFormField(
      controller: _fullNameController,
      hint: AppTexts.fullName,
      prefixIcon: Icons.person,
      keyboardType: TextInputType.text,
      validator: AppValidators.validateFullName(),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return CustomTextFormField(
      controller: _phoneController,
      hint: AppTexts.phoneNumber,
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      // validator: AppValidators.validatePhoneNumber(),
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextFormField(
      controller: _passwordController,
      hint: AppTexts.password,
      prefixIcon: Icons.lock,
      isPassword: true,
      validator: AppValidators.validatePassword(),
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return CustomTextFormField(
      controller: _confirmPasswordController,
      hint: AppTexts.confirmPassword,
      prefixIcon: Icons.lock,
      isPassword: true,
      validator: AppValidators.validateConfirmPassword(_passwordController),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: CustomButton(text: AppTexts.signUp, onPressed: _signUp),
    );
  }

  Widget _buildLoginText() {
    return ClickableTextPair(
      firstText: AppTexts.alreadyHaveAccount,
      secondText: AppTexts.loginHere,
      onSecondTextTap: () {
        context.pop();
      },
    );
  }

  /// Signup Function
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Process data
      debugPrint('Full Name: ${_fullNameController.text}');
      debugPrint('Phone: ${_phoneController.text}');
      debugPrint('Password: ${_passwordController.text}');
      debugPrint('Confirm Password: ${_confirmPasswordController.text}');
      final params = SignUpRequestModel(
        lastName: '',
        firstName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        isConsumer: appRole == AppRole.consumer,
        isMerchant: appRole == AppRole.merchant,
      );

      ref.read(authNotifierProvider.notifier).signup(params);

      // context.pushNamed(
      //   AppRoutes.verifyOtp,
      //   extra: _phoneController.text.trim(),
      // );
    }
  }

  /// Fill mock details for testing
  void _fillMockDetails() {
    _fullNameController.text = 'John Doe';
    _phoneController.text = '1234567890';
    _passwordController.text = 'Test@123456';
    _confirmPasswordController.text = 'Test@123456';
    debugPrint('Dummy values filled for signup');
  }
}
