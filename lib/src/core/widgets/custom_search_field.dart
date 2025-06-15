// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../constants/app_palette.dart';

// class CustomSearchField extends StatelessWidget {
//   final TextEditingController controller;
//   final String? hintText;
//   final Function(String)? onChanged;
//   final Function()? onClear;
//   final bool autofocus;
//   final FocusNode? focusNode;

//   const CustomSearchField({
//     super.key,
//     required this.controller,
//     this.hintText,
//     this.onChanged,
//     this.onClear,
//     this.autofocus = false,
//     this.focusNode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45.h,
//       decoration: BoxDecoration(
//         color: AppPalette.greyColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         autofocus: autofocus,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: hintText ?? 'Search...',
//           hintStyle: TextStyle(color: AppPalette.greyColor, fontSize: 14.sp),
//           prefixIcon: Icon(
//             Icons.search,
//             size: 20.sp,
//             color: AppPalette.greyColor,
//           ),
//           suffixIcon:
//               controller.text.isNotEmpty
//                   ? IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       size: 20.sp,
//                       color: AppPalette.greyColor,
//                     ),
//                     onPressed: () {
//                       controller.clear();
//                       onClear?.call();
//                     },
//                   )
//                   : null,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//             vertical: 12.h,
//           ),
//         ),
//       ),
//     );
//   }
// }
