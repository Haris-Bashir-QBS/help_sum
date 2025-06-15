// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:help_sum/src/core/constants/app_dimensions.dart';
// import 'package:help_sum/src/core/constants/app_palette.dart';
// import 'package:help_sum/src/widgets/custom_text.dart';
// import 'package:help_sum/src/core/constants/asset_paths.dart';
// import 'package:help_sum/src/core/router/app_routes.dart';

// class ServiceProviderCard extends StatelessWidget {
//   final String merchantName;
//   final String profession;
//   final String rating;
//   final String distance;
//   final String imageUrl;

//   const ServiceProviderCard({
//     super.key,
//     required this.merchantName,
//     required this.profession,
//     required this.rating,
//     required this.distance,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(radius: 30.r, backgroundImage: NetworkImage(imageUrl)),
//           15.horizontalSpace,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: merchantName,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 5.verticalSpace,
//                 CustomText(
//                   text: profession,
//                   fontSize: 14.sp,
//                   color: AppPalette.lightGreyColor,
//                 ),
//                 5.verticalSpace,
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: AppPalette.starColor, size: 16.w),
//                     5.horizontalSpace,
//                     CustomText(text: rating, fontSize: 12.sp),
//                     10.horizontalSpace,
//                     Icon(
//                       Icons.location_on,
//                       color: AppPalette.greyColor,
//                       size: 16.w,
//                     ),
//                     5.horizontalSpace,
//                     CustomText(text: distance, fontSize: 12.sp),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               IconButton(
//                 icon: Image.asset(
//                   AppAssets.ic_chat,
//                   color: AppPalette.blackColor,
//                   width: 24.w,
//                   height: 24.h,
//                 ),
//                 onPressed: () {
//                   // TODO: Implement chat functionality
//                 },
//               ),
//               IconButton(
//                 icon: Image.asset(
//                   AppAssets.ic_target,
//                   color: AppPalette.blackColor,
//                   width: 24.w,
//                   height: 24.h,
//                 ),
//                 onPressed: () {
//                   context.pushNamed(AppRoutes.mapTracking);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
