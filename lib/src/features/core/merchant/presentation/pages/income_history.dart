import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart'; // For NumberFormat if you want to format currency

// You can move this enum to a separate file if you use it elsewhere
enum TimePeriod { weekly, monthly, yearly }

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  TimePeriod _selectedPeriod = TimePeriod.weekly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      body: SafeArea(
        child: Column(
          children: [
            _buildTotalIncomeCard(),
            _buildDateNavigator(),
            Row(
              children: [
                Expanded(child: _buildTimePeriodToggle()),

                // Container(
                //   padding: EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     color: AppPalette.backgroundColor,
                //   ),
                //   child: Icon(Icons.filter_list),
                // ),
                16.horizontalSpace,
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                children: [
                  _buildJobTypeCard(
                    letter: 'S',
                    title: 'Scheduled',
                    jobCount: 2,
                    averageIncome: 20.80,
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(height: 10.h),
                  _buildJobTypeCard(
                    letter: 'I',
                    title: 'Immediate',
                    jobCount: 0,
                    averageIncome: 0.00,
                    color: Colors.orange.shade700,
                  ),
                  SizedBox(height: 10.h),
                  _buildJobTypeCard(
                    letter: 'C',
                    title: 'Contract',
                    jobCount: 0,
                    averageIncome: 0.00,
                    color: Colors.amber.shade800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalIncomeCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppPalette.backgroundColor, // Vibrant blue from screenshot
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: AppPalette.primaryColor,
            ),
            child: CustomText(
              text: 'Total Income',
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              textAlign: TextAlign.center,
              color: AppPalette.backgroundColor,
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: CustomText(
              text:
                  '\$ ${_selectedPeriod == TimePeriod.monthly
                      ? "10.90"
                      : _selectedPeriod == TimePeriod.weekly
                      ? "6.4"
                      : "200"}',
              textAlign: TextAlign.center,
              fontSize: 30.sp,
              // fontWeight: FontWeight.bold,
              // style: TextStyle(
              //   color: Colors.white,
              //   fontSize: 40.sp,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'No of jobs: 2',
                  fontSize: 14.sp,
                  // style: TextStyle(
                  //   color: Colors.black.withOpacity(0.9),
                  //   fontSize: 14.sp,
                  // ),
                ),
                CustomText(
                  text: 'Average Income: \$20.80',
                  fontSize: 14.sp,
                  //   style: TextStyle(
                  //     color: Colors.white.withOpacity(0.9),
                  //     fontSize: 14.sp,
                  //   ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade700,
              size: 20.sp,
            ),
            onPressed: () {
              // Handle previous week/month/year
            },
          ),
          Text(
            '16 - 23 May, 2023',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade700,
              size: 20.sp,
            ),
            onPressed: () {
              // Handle next week/month/year
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildToggleOption(TimePeriod.weekly, 'Weekly'),
          _buildToggleOption(TimePeriod.monthly, 'Monthly'),
          _buildToggleOption(TimePeriod.yearly, 'Yearly'),
        ],
      ),
    );
  }

  Widget _buildToggleOption(TimePeriod period, String text) {
    final bool isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFFFF9800)
                    : Colors.transparent, // Orange when selected
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobTypeCard({
    required String letter,
    required String title,
    required int jobCount,
    required double averageIncome,
    required Color color,
  }) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 0,
      // elevation: 2,
      // shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: color,
              child: Text(
                letter,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // SizedBox(height: .w),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      width: 4.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No. of jobs: $jobCount',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Average Income: \$${averageIncome.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
