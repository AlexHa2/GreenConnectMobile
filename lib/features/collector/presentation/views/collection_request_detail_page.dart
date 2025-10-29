import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/collection_step_indicator.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/completion_view.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/confirm_schedule_view.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/reschedule_date_time_dialog.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/widgets/scrap_item_input.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CollectionRequestDetailPage extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const CollectionRequestDetailPage({
    super.key,
    required this.jobData,
  });

  @override
  State<CollectionRequestDetailPage> createState() =>
      _CollectionRequestDetailPageState();
}

class _CollectionRequestDetailPageState
    extends State<CollectionRequestDetailPage> {
  int _currentStep = 1;
  DateTime _proposedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _proposedTime = const TimeOfDay(hour: 10, minute: 0);

  final List<Map<String, dynamic>> _scrapItems = [
    {
      'name': 'Giấy các loại',
      'value': '50,000',
      'editable': false,
    },
    {
      'name': 'Chai nhựa (PET, HDPE)',
      'value': '',
      'editable': true,
      'controller': TextEditingController(),
    },
    {
      'name': 'Nhôm, kim loại khá',
      'value': '120,000',
      'editable': false,
    },
    {
      'name': 'Đồ điện tử cũ',
      'value': '',
      'editable': true,
      'controller': TextEditingController(),
    },
  ];

  @override
  void dispose() {
    for (var item in _scrapItems) {
      if (item['controller'] != null) {
        (item['controller'] as TextEditingController).dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: theme.primaryColorDark,
          ),
        ),
        title: Text(
          'Collection Request Detail',
          style: textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.screenPadding * 2,
          vertical: spacing.screenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Step Indicator
              CollectionStepIndicator(
                currentStep: _currentStep,
                steps: const [
                  {'number': 1, 'label': 'review'},
                  {'number': 2, 'label': 'Confirm'},
                  {'number': 3, 'label': 'Complete'},
                ],
              ),

              SizedBox(height: spacing.screenPadding * 2.5),

              // Content based on step
              if (_currentStep == 3)
                Expanded(
                  child: CompletionView(
                    onBackToBooking: () {
                      // Navigate back to dashboard or browse jobs
                      context.go('/collector-dashboard');
                    },
                  ),
                )
              else if (_currentStep == 2)
                Expanded(
                  child: ConfirmScheduleView(
                    proposedDate: _proposedDate,
                    proposedTime: _proposedTime,
                    onConfirm: () {
                      setState(() {
                        _currentStep = 3;
                      });
                      // TODO: API call to confirm schedule
                    },
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                // Title
                Text(
                  'Scarp Collection\nRequest',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    fontSize: 28,
                  ),
                ),

                SizedBox(height: spacing.screenPadding * 2),

              // Collection Address
              _buildInfoRow(
                context,
                icon: Icons.location_on,
                iconColor: AppColors.primary,
                title: 'collection Address',
                subtitle: '123 Green st, Eco District',
              ),

              SizedBox(height: spacing.screenPadding * 1.2),

              // Proposed Date
              _buildInfoRow(
                context,
                icon: Icons.calendar_today,
                iconColor: AppColors.primary,
                title: 'Proposed Date',
                subtitle: DateFormat('EEEE, MMMM dd, yyyy').format(_proposedDate),
              ),

              SizedBox(height: spacing.screenPadding * 1.2),

              // Time Slot
              _buildInfoRow(
                context,
                icon: Icons.access_time,
                iconColor: AppColors.primary,
                title: 'Time Slot',
                subtitle: '${_proposedTime.format(context)} - ${TimeOfDay(hour: _proposedTime.hour + 2, minute: _proposedTime.minute).format(context)}',
              ),

              SizedBox(height: spacing.screenPadding * 2),

              // Items Section
              _buildInfoRow(
                context,
                icon: Icons.delete_outline,
                iconColor: AppColors.primary,
                title: 'Items',
                subtitle: 'Paper,Plastic, Metal Scraps',
              ),

              SizedBox(height: spacing.screenPadding * 1.5),

              // Scrap Items List
              ..._scrapItems.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing.screenPadding),
                  child: ScrapItemInput(
                    itemName: item['name'],
                    initialValue: item['value'],
                    editable: item['editable'],
                    controller: item['controller'],
                  ),
                );
              }),

              // Add more button
              InkWell(
                onTap: () {
                  // TODO: Add more item
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.screenPadding),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Icon(
                        Icons.add_circle_outline,
                        color: theme.textTheme.bodyMedium?.color,
                        size: 20,
                      ),
                      SizedBox(width: spacing.screenPadding),
                      Text(
                        'Thêm loại khá...',
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: spacing.screenPadding * 2),

              // Total Estimate
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.screenPadding * 1.5,
                  vertical: spacing.screenPadding * 1.2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(spacing.screenPadding / 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding),
                    Text(
                      'Tổng tiền ước tính:',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '170,000 VND',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing.screenPadding * 2),

              // Eco Impact
              Container(
                padding: EdgeInsets.all(spacing.screenPadding * 1.5),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(spacing.screenPadding),
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(spacing.screenPadding / 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.energy_savings_leaf,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: spacing.screenPadding * 1.2),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                            height: 1.5,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: 'Eco Impact : ',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  'this collection will help recycle approximately 15kg of materials, saving energy equivalent to powering a home for 2 days',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing.screenPadding * 2.5),

              // Accept Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Accept collection
                    setState(() {
                      _currentStep = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.screenPadding * 1.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        spacing.screenPadding * 1.5,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Accept Collection',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: spacing.screenPadding * 1.5),

              // Reschedule and Cancel buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => RescheduleDateTimeDialog(
                            initialDate: _proposedDate,
                            onConfirm: (selectedDate, selectedTime) {
                              setState(() {
                                _proposedDate = selectedDate;
                                _proposedTime = selectedTime;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Rescheduled to ${DateFormat('MMM dd, yyyy').format(selectedDate)} at ${selectedTime.format(context)}',
                                  ),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.screenPadding * 1.5,
                        ),
                        side: BorderSide(
                          color: theme.dividerColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            spacing.screenPadding * 1.2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Reschedule',
                        style: textTheme.titleMedium?.copyWith(
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.screenPadding * 1.5),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Cancel
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.screenPadding * 1.5,
                        ),
                        side: const BorderSide(
                          color: AppColors.warningUpdate,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            spacing.screenPadding * 1.2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancle',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.warningUpdate,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.screenPadding * 3),
                      ], // Close Column children
                    ),
                  ),
                ), // Close Expanded and else
            ],
          ),
        ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
        SizedBox(width: spacing.screenPadding * 1.2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

