import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/clickable_text_pair.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  late final LoginBloc _loginBloc;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _loginBloc = sl<LoginBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (ctx, state) {
          _navigateToSpecificScreen(state, context);
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

                        // Illustration
                        AnimatedSlideFade(
                          delayMilliseconds: 0,
                          child: _buildIllustration(),
                        ),

                        30.verticalSpace,

                        // Title
                        AnimatedSlideFade(
                          delayMilliseconds: 100,
                          child: _buildLoginTitle(),
                        ),

                        10.verticalSpace,

                        // Subtitle
                        AnimatedSlideFade(
                          delayMilliseconds: 200,
                          child: _buildSubTitle(),
                        ),

                        50.verticalSpace,

                        // Phone field
                        AnimatedSlideFade(
                          delayMilliseconds: 300,
                          child: _buildPhoneNumberTextField(),
                        ),

                        15.verticalSpace,

                        // Password field
                        AnimatedSlideFade(
                          delayMilliseconds: 400,
                          child: _buildPasswordTextField(),
                        ),

                        60.verticalSpace,

                        // Login button
                        AnimatedSlideFade(
                          delayMilliseconds: 500,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.w),
                            child: CustomButton(
                              text: AppTexts.login,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                    LoginUser(
                                      phoneNumber: _phoneController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        26.verticalSpace,

                        // Signup text
                        AnimatedSlideFade(
                          delayMilliseconds: 600,
                          child: _buildSignUpText(),
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

  void _navigateToSpecificScreen(LoginState state, BuildContext context) {
    if (state.apiErrorMessage.isNotEmpty) {
      CustomToast.errorToast(context: context, message: state.apiErrorMessage);
    } else if (state.userEntity != null) {
      if (state.userEntity!.isVerified == false) {
        context.goNamed(
          AppRoutes.verifyOtp,
          extra: {
            'userId': state.userEntity!.id,
            'phone': state.userEntity!.phone,
          },
        );
      } else {
        final user = state.userEntity!;

        if (user.role != AppRole.consumer.name) {
          if (user.services?.isEmpty == true) {
            context.goNamed(AppRoutes.selectSkill);
          } else if (user.schedule?.isEmpty == true) {
            context.goNamed(AppRoutes.createSchedule);
          } else {
            context.goNamed(AppRoutes.mainNavigation);
          }
        } else {
          context.goNamed(AppRoutes.mainNavigation);
        }
      }
    }
  }

  Widget _buildSubTitle() =>
      CustomText(text: AppTexts.loginSubtitle, fontSize: 16.sp, maxLines: 3);

  Widget _buildIllustration() => GestureDetector(
    onTap: _fillMockDetails,
    child: Image.asset(AppAssets.appLogo, height: 160.h, fit: BoxFit.cover),
  );

  Widget _buildLoginTitle() => CustomText(
    text: AppTexts.welcome,
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
  );

  Widget _buildPhoneNumberTextField() => CustomTextFormField(
    controller: _phoneController,
    hint: AppTexts.phoneNumber,
    prefixIcon: Icons.phone,
    keyboardType: TextInputType.phone,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    validator: AppValidators.validatePhoneNumber(),
  );

  Widget _buildPasswordTextField() => CustomTextFormField(
    controller: _passwordController,
    hint: AppTexts.password,
    prefixIcon: Icons.lock,
    isPassword: true,
    validator: AppValidators.validateEmpty(AppTexts.password),
  );

  Widget _buildSignUpText() => ClickableTextPair(
    firstText: AppTexts.dontHaveAccount,
    secondText: AppTexts.signUp,
    onSecondTextTap: () => context.pushNamed(AppRoutes.signUp),
  );

  void _fillMockDetails() {
    if (kDebugMode) {
      _phoneController.text = '03223423300';
      _passwordController.text = 'Abcd@1234';
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
