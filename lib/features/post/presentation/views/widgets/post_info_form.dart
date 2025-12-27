import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/app_input_field.dart';
import 'package:flutter/material.dart';

class PostInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController addressController;
  final VoidCallback onSearchAddress;
  final VoidCallback? onGetCurrentLocation;
  final bool addressFound;
  final bool isLoadingLocation;
  final String? addressValidationError;

  const PostInfoForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.addressController,
    required this.onSearchAddress,
    required this.addressFound,
    this.onGetCurrentLocation,
    this.isLoadingLocation = false,
    this.addressValidationError,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context)!.pickup_address,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Address Display with Badge
                if (addressController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha:0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            addressController.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        if (addressFound)
                          Icon(
                            Icons.verified,
                            color: theme.primaryColor,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                
                // Address Picker Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onGetCurrentLocation,
                    icon: const Icon(Icons.edit_location_alt),
                    label: Text(
                      addressController.text.isEmpty
                          ? S.of(context)!.select_address
                          : S.of(context)!.change_address,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: addressValidationError != null
                            ? theme.colorScheme.error
                            : theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                
                // Show address validation error
                if (addressValidationError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      addressValidationError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                
                // Hidden validator field
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    constraints: BoxConstraints(maxHeight: 0),
                  ),
                  style: const TextStyle(fontSize: 0, height: 0),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return S.of(context)!.error_required;
                    }
                    return null;
                  },
                ),
              ],
            ),

            SizedBox(height: spacing.screenPadding),
          ],
        ),
      ),
    );
  }
}
