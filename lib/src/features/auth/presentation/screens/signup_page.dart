import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/clickable_text_pair.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final SignupBloc _signupBloc;

  @override
  void initState() {
    _signupBloc = sl<SignupBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _signupBloc,
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.userId.isNotEmpty) {
            context.goNamed(
              AppRoutes.verifyOtp,
              extra: {'userId': state.userId, 'phone': _phoneController.text},
            );
          }

          if (state.apiErrorMessage.isNotEmpty) {
            CustomToast.errorToast(
              context: context,
              message: state.apiErrorMessage,
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.isLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        140.verticalSpace,
                        AnimatedSlideFade(
                          delayMilliseconds: 0,
                          child: _buildIllustration(),
                        ),

                        // 40.verticalSpace,
                        AnimatedSlideFade(
                          delayMilliseconds: 100,
                          child: _buildCreateAccountTitle(),
                        ),
                        10.verticalSpace,
                        AnimatedSlideFade(
                          delayMilliseconds: 100,
                          child: _buildSubTitle(),
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
        },
      ),
    );
  }

  Widget _buildIllustration() {
    return GestureDetector(
      onTap: _fillMockDetails,
      child: Image.asset(AppAssets.appLogo, height: 160.h),
    );
  }

  Widget _buildCreateAccountTitle() {
    return CustomText(
      text: AppTexts.createAccountTitle,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildSubTitle() =>
      CustomText(text: AppTexts.signUpSubtitle, fontSize: 16.sp, maxLines: 3);
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: AppValidators.validatePhoneNumber(),
      // isOutlinedBorder: false,
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

      _signupBloc.add(SignupButtonPressed(signUpRequestModel: params));

      // ref.read(authNotifierProvider.notifier).signup(params);

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
