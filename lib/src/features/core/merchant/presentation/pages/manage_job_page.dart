import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

import '../../../../../core/constants/app_texts.dart';

class ManageJobPage extends StatefulWidget {
  const ManageJobPage({super.key});

  @override
  State<ManageJobPage> createState() => _ManageJobPageState();
}

class _ManageJobPageState extends State<ManageJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedReason;
  String? _selectedTime;
  String? _amount;
  String? _note;

  final List<String> _reasons = ['Sick', 'Emergency', 'Reschedule'];
  final List<String> _timeSlots = ['1-2 hr', '2-3 hr', '3-4 hr'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Manage Your Job"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                30.verticalSpace,
                _buildDropdownRowField(
                  icon: Icons.info_outline,
                  hint: "Select Reason",
                  value: _selectedReason,
                  items: _reasons,
                  onChanged: (val) => setState(() => _selectedReason = val),
                ),
                const SizedBox(height: 16),
                _buildDropdownRowField(
                  icon: Icons.access_time,
                  hint: "Select Time",
                  value: _selectedTime,
                  items: _timeSlots,
                  onChanged: (val) => setState(() => _selectedTime = val),
                ),
                const SizedBox(height: 16),
                _buildRowTextFormField(
                  icon: Icons.monetization_on_outlined,
                  hint: "Amount",
                  keyboardType: TextInputType.number,
                  validator:
                      (val) =>
                          val == null || val.isEmpty ? "Enter amount" : null,
                  onSaved: (val) => _amount = val,
                ),
                const SizedBox(height: 16),
                _buildRowTextFormField(
                  icon: Icons.file_copy_outlined,
                  hint: "Add Note (optional)",
                  keyboardType: TextInputType.text,
                  validator: (val) => null,
                  onSaved: (val) => _note = val,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: AppTexts.done,
                        color: AppPalette.orangeColor,
                        onPressed: () {
                          context.pop(true);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton.bordered(
                        text: AppTexts.cancel,
                        borderColor: AppPalette.orangeColor,
                        textColor: AppPalette.orangeColor,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRowField({
    required IconData icon,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
              ), // Increased padding
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Lighter underline
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Lighter underline
              ),
            ),

            validator:
                (val) =>
                    val == null || val.isEmpty ? 'Please select $hint' : null,
            items:
                items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildRowTextFormField({
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
              ), // Increased padding
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Lighter underline
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Lighter underline
              ),
            ),

            keyboardType: keyboardType,
            validator: validator,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}
