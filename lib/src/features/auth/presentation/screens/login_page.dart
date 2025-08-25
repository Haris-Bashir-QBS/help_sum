// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:help_sum/src/core/constants/app_role.dart';
// import 'package:help_sum/src/core/constants/app_texts.dart';
// import 'package:help_sum/src/core/constants/asset_paths.dart';
// import 'package:help_sum/src/core/router/app_routes.dart';
// import 'package:help_sum/src/core/utils/app_validators.dart';
// import 'package:help_sum/src/features/auth/data/models/request/login_request_model.dart';
// import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
// import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
// import 'package:help_sum/src/widgets/animated_slide_fade.dart';
// import 'package:help_sum/src/widgets/clickable_text_pair.dart';
// import 'package:help_sum/src/widgets/custom_button.dart';
// import 'package:help_sum/src/widgets/custom_text.dart';
// import 'package:help_sum/src/widgets/custom_text_formfield.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:help_sum/src/widgets/custom_toast.dart';

// import '../../../../widgets/modal_progress_hud.dart';

// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _listener() {
//     ref.listen<AuthState>(authNotifierProvider, (prev, next) {
//       if (next is LoginSuccess) {
//         if (next.user.isVerified == false) {
//           context.goNamed(
//             AppRoutes.verifyOtp,
//             extra: {'userId': next.user.id, 'phone': next.user.phone},
//           );
//         } else {
//           // context.goNamed(AppRoutes.mainNavigation);

//           if (next.user.role != AppRole.consumer.name &&
//               //  next.user.isCompleted == false) {
//               (next.user.services?.isEmpty == true ||
//                   next.user.schedule?.isEmpty == true)) {
//             context.goNamed(AppRoutes.selectSkill);
//           } else {
//             context.goNamed(AppRoutes.mainNavigation);
//           }
//         }

//         // ref.read(authNotifierProvider.notifier).reset();
//       }

//       if (next is LoginError) {
//         CustomToast.errorToast(context: context, message: next.message);
//         // ScaffoldMessenger.of(
//         //   context,
//         // ).showSnackBar(SnackBar(content: Text(next.message)));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _listener();

//     final AuthState authState = ref.watch(authNotifierProvider);
//     final isLoading = authState is LoginLoading;

//     return ModalProgressHUD(
//       inAsyncCall: isLoading,

//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   140.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 0,
//                     child: _buildIllustration(),
//                   ),
//                   72.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 100,
//                     child: _buildLoginTitle(),
//                   ),
//                   72.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 200,
//                     child: _buildPhoneNumberTextField(),
//                   ),
//                   15.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 300,
//                     child: _buildPasswordTextField(),
//                   ),
//                   60.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 400,
//                     child: _buildLoginButton(),
//                   ),
//                   26.verticalSpace,
//                   AnimatedSlideFade(
//                     delayMilliseconds: 500,
//                     child: _buildSignUpText(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIllustration() {
//     return GestureDetector(
//       onTap: _fillMockDetails,
//       child: Image.asset(AppAssets.authIllustrationIcon, height: 200.h),
//     );
//   }

//   Widget _buildLoginTitle() {
//     return CustomText(
//       text: AppTexts.loginAccountTitle,
//       fontSize: 24.sp,
//       fontWeight: FontWeight.bold,
//     );
//   }

//   Widget _buildPhoneNumberTextField() {
//     return CustomTextFormField(
//       controller: _phoneController,
//       hint: AppTexts.phoneNumber,
//       prefixIcon: Icons.phone,
//       keyboardType: TextInputType.phone,
//       validator: AppValidators.validatePhoneNumber(),
//     );
//   }

//   Widget _buildPasswordTextField() {
//     return CustomTextFormField(
//       controller: _passwordController,
//       hint: AppTexts.password,
//       prefixIcon: Icons.lock,
//       isPassword: true,
//       validator: AppValidators.validateEmpty(AppTexts.password),
//     );
//   }

//   Widget _buildLoginButton() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 48.w),
//       child: CustomButton(
//         text: AppTexts.login,
//         onPressed: _login,
//         //color: context.primaryColor,
//       ),
//     );
//   }

//   Widget _buildSignUpText() {
//     return ClickableTextPair(
//       firstText: AppTexts.dontHaveAccount,
//       secondText: AppTexts.signUp,
//       onSecondTextTap: () => context.pushNamed(AppRoutes.signUp),
//     );
//   }

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       final params = LoginRequestModel(
//         phoneNumber: _phoneController.text,
//         password: _passwordController.text,
//       );
//       ref.read(authNotifierProvider.notifier).login(params, context: context);
//     }
//   }

//   void _fillMockDetails() {
//     if (kDebugMode) {
//       _phoneController.text = '923188912022';
//       _passwordController.text = 'Abcd@1234';
//       debugPrint('Dummy values filled for login');
//     }
//   }

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
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
        listener: (context, state) {
          if (state.apiErrorMessage != '') {
            CustomToast.errorToast(
              context: context,
              message: state.apiErrorMessage,
            );
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
              // context.goNamed(AppRoutes.mainNavigation);

              if (state.userEntity!.role != AppRole.consumer.name &&
                  //  state.userEntity!.isCompleted == false) {
                  (state.userEntity!.services?.isEmpty == true ||
                      state.userEntity!.schedule?.isEmpty == true)) {
                context.goNamed(AppRoutes.selectSkill);
              } else {
                context.goNamed(AppRoutes.mainNavigation);
              }
            }
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
                        _buildIllustration(),
                        30.verticalSpace,
                        _buildLoginTitle(),
                        10.verticalSpace,
                        _buildSubTitle(),
                        50.verticalSpace,
                        _buildPhoneNumberTextField(),
                        15.verticalSpace,
                        _buildPasswordTextField(),
                        60.verticalSpace,
                        CustomButton(
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
                        26.verticalSpace,
                        _buildSignUpText(),
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

  Widget _buildSubTitle() =>
      CustomText(text: AppTexts.loginSubtitle, fontSize: 16.sp, maxLines: 3);

  Widget _buildIllustration() => GestureDetector(
    onTap: _fillMockDetails,
    child: Image.asset(AppAssets.appLogo, height: 180.h, fit: BoxFit.contain),
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
      _phoneController.text = '923188912022';
      _passwordController.text = 'Abcd@1234';
    }
  }
}
