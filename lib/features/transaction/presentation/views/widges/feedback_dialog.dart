import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<void> showFeedbackDialog({
  required BuildContext context,
  required double initialRating,
  required TextEditingController reviewController,
  required VoidCallback onSubmit,
  required ValueChanged<double> onRatingChange,
}) async {
  final theme = Theme.of(context);
  final spacing = theme.extension<AppSpacing>()!;
  final space = spacing.screenPadding;
  final s = S.of(context)!;

  bool isComplaint = false;
  File? selectedImage;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
            );

            if (pickedFile != null) {
              setState(() {
                selectedImage = File(pickedFile.path);
              });
            }
          }

          return Dialog(
            insetPadding: EdgeInsets.all(space),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(space),
            ),
            backgroundColor: theme.cardColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(space * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${s.how_was_your_transaction} ?",
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: space * 2),
                      ),
                    ],
                  ),
                  SizedBox(height: space * 2),

                  Text(
                    s.rating,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: space / 2),
                  RatingBar.builder(
                    initialRating: initialRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    unratedColor: theme.dividerColor,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: theme.primaryColor),
                    itemPadding: EdgeInsets.symmetric(horizontal: space / 3),
                    onRatingUpdate: onRatingChange,
                  ),
                  SizedBox(height: space),

                  Text(
                    s.your_review,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: space / 2),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: InputDecoration(hintText: s.your_review_hint),
                  ),
                  SizedBox(height: space),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: space),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(space),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.danger,
                        ),
                        SizedBox(width: space),
                        Expanded(
                          child: Text(
                            s.report_an_issue,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        Switch(
                          value: isComplaint,
                          onChanged: (value) {
                            setState(() {
                              isComplaint = value;
                            });
                          },
                          activeColor: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),

                  if (isComplaint) ...[
                    SizedBox(height: space),
                    Text(
                      s.attach_photo,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: space / 2),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Center(
                          child: selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 28,
                                    ),
                                    SizedBox(height: space / 2),
                                    Text(s.tap_to_upload_photo),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: space),
                    Text(
                      s.your_review,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: space / 2),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: s.decribe_your_issue_hint,
                      ),
                    ),
                  ],

                  SizedBox(height: space * 2),

                  GradientButton(
                    onPressed: () {
                      onSubmit();
                      Navigator.pop(context);
                    },
                    text: s.submit_feedback,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
