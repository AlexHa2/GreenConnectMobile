import 'package:GreenConnectMobile/features/transaction/presentation/views/widges/feedback_dialog.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/widgets/lable_field.dart';
import 'package:flutter/material.dart';

class ConfirmTransaction extends StatefulWidget {
  const ConfirmTransaction({super.key});

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final s = S.of(context)!;
    final space = spacing.screenPadding;
    bool isComplaint = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.confirm_details, style: theme.appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(space),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: space * 2),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: space * 2,
                vertical: space,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(space),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: theme.primaryColor,
                    size: space * 2,
                  ),
                  SizedBox(width: space),
                  Expanded(
                    child: Text(
                      "Meeting confirmed\nTomorrow at 2:00 PM downtown community garden",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? theme.primaryColorLight
                            : theme.primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: space * 2),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: space * 2,
                vertical: space * 2,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(space),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.transaction_detail,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: space * 1.5,
                    ),
                  ),

                  SizedBox(height: space * 2),

                  LableField(
                    label: s.weight,
                    controller: TextEditingController(text: "15 kg"),
                    hint: s.weight_hint,
                  ),

                  SizedBox(height: space),

                  LableField(
                    label: s.value,
                    controller: TextEditingController(text: "\$30"),
                    hint: s.value_hint,
                  ),

                  SizedBox(height: space * 3),

                  GradientButton(
                    onPressed: () {
                      showFeedbackDialog(
                        context: context,
                        initialRating: 4,
                        reviewController: TextEditingController(),
                        onSubmit: () {
                          Navigator.pop(context);
                        },
                        onRatingChange: (rating) {
                          // Update rating state
                        },
                      );
                    },
                    text: s.approve_transaction,
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),

            SizedBox(height: space * 3),

            // Footer text
            Center(
              child: Column(
                children: [
                  Text(
                    s.slogan_confirm_detail_1,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(s.slogan_confirm_detail_2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
