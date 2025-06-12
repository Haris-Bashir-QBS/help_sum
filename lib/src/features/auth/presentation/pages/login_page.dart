import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/clickable_text_pair.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                72.verticalSpace,
                AnimatedSlideFade(
                  delayMilliseconds: 100,
                  child: _buildLoginTitle(),
                ),
                72.verticalSpace,
                AnimatedSlideFade(
                  delayMilliseconds: 200,
                  child: _buildPhoneNumberTextField(),
                ),
                15.verticalSpace,
                AnimatedSlideFade(
                  delayMilliseconds: 300,
                  child: _buildPasswordTextField(),
                ),
                60.verticalSpace,
                AnimatedSlideFade(
                  delayMilliseconds: 400,
                  child: _buildLoginButton(),
                ),
                26.verticalSpace,
                AnimatedSlideFade(
                  delayMilliseconds: 500,
                  child: _buildSignUpText(),
                ),
              ],
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

  Widget _buildLoginTitle() {
    return CustomText(
      text: AppTexts.loginAccountTitle,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildPhoneNumberTextField() {
    return CustomTextFormField(
      controller: _phoneController,
      hint: AppTexts.phoneNumber,
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: AppValidators.validatePhoneNumber(),
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextFormField(
      controller: _passwordController,
      hint: AppTexts.password,
      prefixIcon: Icons.lock,
      isPassword: true,
      validator: AppValidators.validateEmpty(AppTexts.password),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: CustomButton(text: AppTexts.login, onPressed: _login),
    );
  }

  Widget _buildSignUpText() {
    return ClickableTextPair(
      firstText: AppTexts.dontHaveAccount,
      secondText: AppTexts.signUp,
      onSecondTextTap: () {
        context.pushNamed(AppRoutes.signUp);
      },
    );
  }

  /// Login Method
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Process data
      debugPrint('Phone: ${_phoneController.text}');
      debugPrint('Password: ${_passwordController.text}');
      context.goNamed(AppRoutes.mainNavigation);
    }
  }

  /// Fill mock details for testing
  void _fillMockDetails() {
    _phoneController.text = '1234567890';
    _passwordController.text = 'Test@123';
    debugPrint('Dummy values filled for login');
  }
}
