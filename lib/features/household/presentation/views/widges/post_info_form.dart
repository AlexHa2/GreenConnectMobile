import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/app_input_field.dart';
import 'package:flutter/material.dart';

class PostInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController addressController;
  final TextEditingController timeController;
  final VoidCallback onSearchAddress;
  final bool addressFound;

  const PostInfoForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.addressController,
    required this.timeController,
    required this.onSearchAddress,
    required this.addressFound,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.screenPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInputField(
              label: S.of(context)!.post_title,
              controller: titleController,
              hint: S.of(context)!.post_title_hint,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return S.of(context)!.error_required;
                }
                if (v.trim().length < 3) {
                  return S.of(context)!.error_post_title_min;
                }
                return null;
              },
            ),

            SizedBox(height: spacing.screenPadding),
            AppInputField(
              label: S.of(context)!.description,
              controller: descController,
              hint: S.of(context)!.description_hint,
              maxLines: 2,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return S.of(context)!.error_required;
                }
                if (v.trim().length < 10) {
                  return S.of(context)!.error_description_min;
                }
                return null;
              },
            ),

            SizedBox(height: spacing.screenPadding),
            AppInputField(
              label: S.of(context)!.pickup_address,
              controller: addressController,
              hint: S.of(context)!.street_address_location_hint,
              maxLines: 2,
              suffixIcon: IconButton(
                icon: Icon(
                  addressFound ? Icons.check_circle : Icons.search,
                  color: addressFound
                      ? theme.primaryColor
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: onSearchAddress,
              ),
              validator: (v){
                if (v == null || v.isEmpty) {
                  return S.of(context)!.error_required;
                }
                return null;
              },
            ),

            SizedBox(height: spacing.screenPadding),
            AppInputField(
              label: S.of(context)!.pickup_time,
              controller: timeController,
              hint: S.of(context)!.pickup_time_hint,
            ),
          ],
        ),
      ),
    );
  }
}
