import 'package:GreenConnectMobile/features/transaction/presentation/views/widges/circle_step.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/widges/infor_field.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/select_meeting_time.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.transaction_detail,
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: space),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleStep(
                  icon: Icons.schedule,
                  label: "Schedule",
                  active: true,
                  theme: theme,
                ),
                Container(
                  width: space * 10,
                  height: 2,
                  color: theme.primaryColorDark.withValues(alpha: 0.6),
                ),
                CircleStep(
                  icon: Icons.check_circle_outline,
                  label: "Complete",
                  active: false,
                  theme: theme,
                ),
              ],
            ),
            SizedBox(height: space * 3),

            Card(
              child: Padding(
                padding: EdgeInsets.all(space * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.recycling, color: theme.primaryColor),
                        SizedBox(width: space),
                        Text(
                          "Plastic Bottles",
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    SizedBox(height: space * 2),

                    InfoField(
                      icon: Icons.person_pin_circle,
                      title: "Sarah Green",
                      subtitle: "Garden Supplies",
                      theme: theme,
                    ),
                    SizedBox(height: space),

                    InfoField(
                      icon: Icons.location_on,
                      title: "Downtown Community Garden",
                      subtitle: "1.2 km away",
                      theme: theme,
                    ),
                    SizedBox(height: space * 2),

                    // Proposed Time
                    Text(
                      s.proposed_time,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: space / 3),
                    Text("Tomorrow, 2:00 PM", style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            SizedBox(height: space * 3),

            GradientButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                showSelectMeetingDialog(
                  title: s.select_meeting_time,
                  context: context,
                  initialDate: DateTime.now(),
                  onDateSelected: (date) => print("Selected: $date"),
                  onAccept: () => context.push('/confirm-transaction'),
                  onDecline: () => context.pop(),
                );
              },
              text: s.accept_proposed_time,
            ),

            SizedBox(height: space * 3),

            Center(
              child: Text(
                s.by_complete_transaction,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
