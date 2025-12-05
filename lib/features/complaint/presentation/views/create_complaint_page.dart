import 'dart:typed_data';

import 'package:GreenConnectMobile/features/complaint/presentation/providers/complaint_providers.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/utils/utils.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/widgets/widgets.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateComplaintPage extends ConsumerStatefulWidget {
  final String transactionId;

  const CreateComplaintPage({
    super.key,
    required this.transactionId,
  });

  @override
  ConsumerState<CreateComplaintPage> createState() =>
      _CreateComplaintPageState();
}

class _CreateComplaintPageState extends ConsumerState<CreateComplaintPage> {
  final _reasonController = TextEditingController();
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await ComplaintImagePicker.pickImage(context);
    if (result != null) {
      setState(() {
        _selectedImageBytes = result['bytes'] as Uint8List;
        _selectedImageName = result['name'] as String;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImageBytes == null || _selectedImageName == null) {
      return null;
    }

    return await ComplaintImageUploader.uploadImage(
      context: context,
      ref: ref,
      imageBytes: _selectedImageBytes!,
      imageName: _selectedImageName!,
    );
  }

  bool _validateFields(S s) {
    return ComplaintValidators.validateAllFields(
      reason: _reasonController.text,
      hasImage: _selectedImageBytes != null,
      s: s,
      onError: (message) {
        CustomToast.show(context, message, type: ToastType.error);
      },
    );
  }

  Future<void> _handleSubmit() async {
    final s = S.of(context)!;

    // Validate all fields
    if (!_validateFields(s)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {

      // Upload image
      final evidenceUrl = await _uploadImage();

      if (evidenceUrl == null) {
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Create complaint
      final success = await ref
          .read(complaintViewModelProvider.notifier)
          .createComplaint(
            transactionId: widget.transactionId,
            reason: _reasonController.text.trim(),
            evidenceUrl: evidenceUrl,
          );


      setState(() {
        _isSubmitting = false;
      });

      if (success && mounted) {
        CustomToast.show(
          context,
          s.complaint_created_success,
          type: ToastType.success,
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        CustomToast.show(
          context,
          s.failed_to_create_complaint,
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint('❌ ERROR CREATING COMPLAINT: $e');
      if (mounted) {
        
        CustomToast.show(
          context,
          s.error_occurred,
          type: ToastType.error,
        );
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.create_complaint),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: space),
            width: space * 4,
            height: space * 0.4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(space * 0.2),
            ),
          ),

          // Header
          ComplaintHeader(
            title: s.create_complaint,
            subtitle: s.create_complaint_subtitle,
            icon: Icons.report_problem_outlined,
            iconColor: AppColors.danger,
            iconBackgroundColor: AppColors.danger.withValues(alpha: 0.1),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(space * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reason Section
                  ComplaintReasonInput(
                    controller: _reasonController,
                    label: s.complaint_reason,
                    hint: s.enter_complaint_reason_hint,
                    isRequired: true,
                    enabled: !_isSubmitting,
                    helperText: s.minimum_10_characters,
                  ),

                  SizedBox(height: space * 1.5),

                  // Evidence Section
                  ComplaintEvidenceSection(
                    label: s.evidence,
                    isRequired: true,
                    selectedImageBytes: _selectedImageBytes,
                    hasImageAttached: _selectedImageBytes != null,
                    attachedBadgeText: s.image_attached,
                    emptyStateTitle: s.no_evidence_selected,
                    emptyStateSubtitle: s.tap_below_to_select_image,
                    pickButtonText: s.select_evidence_image,
                    changeButtonText: s.change_evidence_image,
                    enabled: !_isSubmitting,
                    onRemoveImage: () {
                      setState(() {
                        _selectedImageBytes = null;
                        _selectedImageName = null;
                      });
                    },
                    onPickImage: _pickImage,
                  ),

                  SizedBox(height: space * 2),

                  // Info note
                  ComplaintInfoNote(
                    message: s.complaint_info_note,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          ComplaintBottomActions(
            cancelText: s.cancel,
            submitText: s.submit_complaint,
            isSubmitting: _isSubmitting,
            submitButtonColor: AppColors.danger,
            submitIcon: Icons.send_outlined,
            onCancel: () => Navigator.pop(context),
            onSubmit: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
