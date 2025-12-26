import 'dart:typed_data';

import 'package:GreenConnectMobile/core/enum/complaint_status.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/core/helper/complaint_status_helper.dart';
import 'package:GreenConnectMobile/core/helper/date_time_extension.dart';
import 'package:GreenConnectMobile/core/helper/transaction_status_helper.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/providers/complaint_providers.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:GreenConnectMobile/shared/widgets/full_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintDetailPage extends ConsumerStatefulWidget {
  final String complaintId;

  const ComplaintDetailPage({super.key, required this.complaintId});

  @override
  ConsumerState<ComplaintDetailPage> createState() =>
      _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends ConsumerState<ComplaintDetailPage> {
  bool _hasChanges = false;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(complaintViewModelProvider.notifier)
          .fetchComplaintDetail(widget.complaintId);
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(complaintViewModelProvider.notifier)
        .fetchComplaintDetail(widget.complaintId);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = image.name;
        });
      }
    } catch (e) {
      debugPrint('❌ ERROR PICKING IMAGE: $e');
      if (mounted) {
        CustomToast.show(
          context,
          S.of(context)!.error_occurred,
          type: ToastType.error,
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImageBytes == null || _selectedImageName == null) {
      return null;
    }

    final uploadNotifier = ref.read(uploadViewModelProvider.notifier);
    final s = S.of(context)!;

    try {
      final contentType = "image/${_selectedImageName!.split('.').last}";

      await uploadNotifier.requestUploadUrlForComplaint(
        UploadFileRequest(
          fileName: _selectedImageName!,
          contentType: contentType,
        ),
      );

      final uploadState = ref.read(uploadViewModelProvider);
      if (uploadState.uploadUrl == null) {
        if (!mounted) return null;
        CustomToast.show(
          context,
          s.cannot_get_uploadurl,
          type: ToastType.error,
        );
        return null;
      }

      await uploadNotifier.uploadBinary(
        uploadUrl: uploadState.uploadUrl!.uploadUrl,
        fileBytes: _selectedImageBytes!,
        contentType: contentType,
      );

      return uploadState.uploadUrl!.filePath;
    } catch (e) {
      debugPrint('❌ ERROR UPLOADING IMAGE: $e');
      if (mounted) {
        CustomToast.show(context, s.error_occurred, type: ToastType.error);
      }
      return null;
    }
  }

  void _showUpdateDialog(ComplaintEntity complaint) {
    final reasonController = TextEditingController(text: complaint.reason);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    // Reset image state
    _selectedImageBytes = null;
    _selectedImageName = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setBottomSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(space * 2),
              ),
            ),
            child: Column(
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
                Container(
                  padding: EdgeInsets.all(space * 1.5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(space * 0.75),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(space),
                        ),
                        child: Icon(
                          Icons.edit_document,
                          color: theme.primaryColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: space),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.update_complaint,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: space * 0.25),
                            Text(
                              s.update_complaint_subtitle,
                              //s.update_complaint_subtitle,
                              //s.update_complaint_subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _selectedImageBytes = null;
                          _selectedImageName = null;
                          Navigator.pop(bottomSheetContext);
                        },
                        icon: Icon(Icons.close_rounded, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(space * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reason Section
                        Container(
                          padding: EdgeInsets.all(space * 1.5),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(space * 1.5),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: space * 0.5),
                                  Text(
                                    s.complaint_reason,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: space),
                              TextField(
                                controller: reasonController,
                                decoration: InputDecoration(
                                  hintText: s.enter_complaint_reason,
                                  hintStyle: TextStyle(
                                    color: theme.hintColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(space),
                                    borderSide: BorderSide(
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(space),
                                    borderSide: BorderSide(
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(space),
                                    borderSide: BorderSide(
                                      color: theme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: theme.scaffoldBackgroundColor,
                                  contentPadding: EdgeInsets.all(space),
                                ),
                                maxLines: 5,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: space * 1.5),

                        // Evidence Section
                        Container(
                          padding: EdgeInsets.all(space * 1.5),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(space * 1.5),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: space * 0.5),
                                  Text(
                                    s.evidence,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_selectedImageBytes != null ||
                                      complaint.evidenceUrl != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: space * 0.75,
                                        vertical: space * 0.25,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          space * 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        s.image_attached,
                                        //s.image_attached,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: space),

                              // Image Preview
                              if (_selectedImageBytes != null)
                                Container(
                                  width: double.infinity,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(space),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          space,
                                        ),
                                        child: Image.memory(
                                          _selectedImageBytes!,
                                          width: double.infinity,
                                          height: 220,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: space * 0.75,
                                        right: space * 0.75,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              setBottomSheetState(() {
                                                _selectedImageBytes = null;
                                                _selectedImageName = null;
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(
                                              space * 2,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                space * 0.5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.7),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: theme
                                                      .scaffoldBackgroundColor
                                                      .withValues(alpha: 0.3),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: theme
                                                    .scaffoldBackgroundColor,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: space * 0.75,
                                        left: space * 0.75,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: space * 0.75,
                                            vertical: space * 0.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.7,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              space * 0.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: theme.primaryColor
                                                    .withValues(alpha: 0.9),
                                                size: 16,
                                              ),
                                              SizedBox(width: space * 0.25),
                                              Text(
                                                s.new_image,
                                                style: theme
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: theme
                                                          .scaffoldBackgroundColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (complaint.evidenceUrl != null)
                                Container(
                                  width: double.infinity,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(space),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(space),
                                    child: Image.network(
                                      complaint.evidenceUrl!,
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: theme.hintColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 48,
                                                    color: theme.hintColor,
                                                  ),
                                                  SizedBox(height: space * 0.5),
                                                  Text(
                                                    s.error_load_image,
                                                    style: theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color:
                                                              theme.hintColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(space * 2),
                                  decoration: BoxDecoration(
                                    color: theme.scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(space),
                                    border: Border.all(
                                      color: theme.dividerColor,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 48,
                                        color: theme.hintColor.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: space * 0.75),
                                      Text(
                                        s.no_evidence_attached,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: theme.hintColor),
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(height: space),

                              // Pick Image Button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await _pickImage();
                                    setBottomSheetState(() {});
                                  },
                                  icon: Icon(
                                    _selectedImageBytes != null
                                        ? Icons.swap_horiz
                                        : Icons.add_photo_alternate_outlined,
                                  ),
                                  label: Text(
                                    _selectedImageBytes != null
                                        ? s.change_evidence_image
                                        : s.add_evidence_image,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: space,
                                    ),
                                    side: BorderSide(
                                      color: theme.primaryColor,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        space,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
                Container(
                  padding: EdgeInsets.all(space * 1.5),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border(
                      top: BorderSide(color: theme.dividerColor, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _selectedImageBytes = null;
                              _selectedImageName = null;
                              Navigator.pop(bottomSheetContext);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: space),
                              side: BorderSide(color: theme.dividerColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(space),
                              ),
                            ),
                            child: Text(s.cancel),
                          ),
                        ),
                        SizedBox(width: space),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: () async {
                              if (reasonController.text.trim().isEmpty) {
                                CustomToast.show(
                                  context,
                                  s.please_enter_reason,
                                  type: ToastType.error,
                                );
                                return;
                              }

                              Navigator.pop(bottomSheetContext);

                              // Show loading
                              if (mounted) {
                                showDialog(
                                  context: this.context,
                                  barrierDismissible: false,
                                  barrierColor: Colors.white.withValues(alpha: 0.8),
                                  builder: (_) => const Center(
                                    child: RotatingLeafLoader(),
                                  ),
                                );
                              }

                              // Check what changed
                              final newReason = reasonController.text.trim();
                              final reasonChanged =
                                  newReason != complaint.reason;

                              // Upload new image only if selected
                              String? newEvidenceUrl;
                              if (_selectedImageBytes != null) {
                                final uploadedUrl = await _uploadImage();
                                if (uploadedUrl != null) {
                                  newEvidenceUrl = uploadedUrl;
                                }
                              }

                              // Update complaint - only pass changed fields
                              final success = await ref
                                  .read(complaintViewModelProvider.notifier)
                                  .updateComplaint(
                                    complaintId: widget.complaintId,
                                    reason: reasonChanged ? newReason : null,
                                    evidenceUrl: newEvidenceUrl,
                                  );

                              // Close loading
                              if (mounted) {
                                Navigator.pop(this.context);
                              }

                              if (success && mounted) {
                                _hasChanges = true;
                                CustomToast.show(
                                  this.context,
                                  s.update_success,
                                  type: ToastType.success,
                                );
                                _selectedImageBytes = null;
                                _selectedImageName = null;
                                _refresh();
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(s.update),
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: space),
                              backgroundColor: AppColors.warningUpdate,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(space),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showReopenDialog() {
    final s = S.of(context)!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.reopen_complaint),
        content: Text(s.reopen_complaint_confirm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(space),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(complaintViewModelProvider.notifier)
                  .reopenComplaint(widget.complaintId);

              if (success && mounted) {
                _hasChanges = true;
                CustomToast.show(
                  // ignore: use_build_context_synchronously
                  context,
                  s.reopen_success,
                  type: ToastType.success,
                );
                _refresh();
              }
            },
            child: Text(s.reopen_complaint),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;

    final vmState = ref.watch(complaintViewModelProvider);
    final complaint = vmState.detailData;
    final isLoading = vmState.isLoadingDetail;
    final isProcessing = vmState.isProcessing;
    final error = vmState.errorMessage;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _hasChanges) {
          // Trigger refresh in list screen
          Future.microtask(() {
            ref
                .read(complaintViewModelProvider.notifier)
                .fetchAllComplaints(pageNumber: 1, pageSize: 10);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.complaint_detail),
          centerTitle: true,
          elevation: 0,
          // actions: [
          //   if (complaint != null &&
          //       ComplaintStatus.fromString(complaint.status.name) ==
          //           ComplaintStatus.submitted)
          //     IconButton(
          //       onPressed: isProcessing
          //           ? null
          //           : () => _showUpdateDialog(complaint),
          //       icon: const Icon(Icons.edit_outlined),
          //       tooltip: s.update_complaint,
          //     ),
          // ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: isLoading && complaint == null
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                  child: const Center(child: RotatingLeafLoader()),
                )
              : error != null && complaint == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.hintColor,
                      ),
                      SizedBox(height: space),
                      Text(s.error_occurred),
                      SizedBox(height: space),
                      ElevatedButton(onPressed: _refresh, child: Text(s.retry)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(space),
                  child: complaint != null
                      ? _buildComplaintContent(
                          complaint,
                          theme,
                          textTheme,
                          space,
                          s,
                          isProcessing,
                        )
                      : const SizedBox(),
                ),
        ),
      ),
    );
  }

  Widget _buildComplaintContent(
    ComplaintEntity complaint,
    ThemeData theme,
    TextTheme textTheme,
    double space,
    S s,
    bool isProcessing,
  ) {
    final status = ComplaintStatus.fromString(complaint.status.name);
    final statusColor = ComplaintStatusHelper.getStatusColor(context, status);
    final statusIcon = ComplaintStatusHelper.getStatusIcon(status);
    final statusLabel = ComplaintStatusHelper.getLocalizedStatus(
      context,
      status,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(space),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(space),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 32),
              SizedBox(width: space),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.status,
                      style: textTheme.labelSmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    Text(
                      statusLabel,
                      style: textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: space * 1.5),

        // Complaint ID & Date
        _buildInfoCard(
          theme,
          textTheme,
          space,
          title: s.complaint_information,
          children: [
            _buildInfoRow(
              s.complaint_id,
              complaint.complaintId,
              theme,
              textTheme,
            ),
            Divider(height: space * 1.5),
            _buildInfoRow(
              s.created_at,
              complaint.createdAt.toCustomFormat(locale: s.localeName),
              theme,
              textTheme,
            ),
          ],
        ),

        SizedBox(height: space * 1.5),

        // Participants
        _buildInfoCard(
          theme,
          textTheme,
          space,
          title: s.participants,
          children: [
            _buildUserSection(
              s.complainant,
              complaint.complainant?.fullName ?? s.unknown,
              complaint.complainant?.phoneNumber,
              complaint.complainant?.avatarUrl,
              theme,
              textTheme,
              space,
            ),
            Divider(height: space * 2),
            _buildUserSection(
              s.accused,
              complaint.accused?.fullName ?? s.unknown,
              complaint.accused?.phoneNumber,
              complaint.accused?.avatarUrl,
              theme,
              textTheme,
              space,
            ),
          ],
        ),

        SizedBox(height: space * 1.5),

        // Reason
        _buildInfoCard(
          theme,
          textTheme,
          space,
          title: s.complaint_reason,
          children: [Text(complaint.reason, style: textTheme.bodyMedium)],
        ),

        SizedBox(height: space * 1.5),

        // Evidence
        if (complaint.evidenceUrl != null) ...[
          _buildInfoCard(
            theme,
            textTheme,
            space,
            title: s.evidence,
            children: [
              GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierLabel: 'Dismiss',
                    barrierColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.8,
                    ),
                    transitionDuration: const Duration(milliseconds: 250),
                    pageBuilder: (_, __, ___) => FullImageViewer(
                      imagePath: complaint.evidenceUrl!,
                      isNetworkImage: true,
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(space),
                  child: Image.network(
                    complaint.evidenceUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: theme.hintColor.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: theme.hintColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: space * 1.5),
        ],

        // Transaction Info
        if (complaint.transaction != null) ...[
          _buildInfoCard(
            theme,
            textTheme,
            space,
            title: s.transaction_information,
            children: [
              _buildInfoRow(
                s.transaction_id,
                complaint.transactionId,
                theme,
                textTheme,
              ),
              Divider(height: space * 1.5),
              _buildInfoRow(
                s.status,
                TransactionStatusHelper.getLocalizedStatus(
                  context,
                  TransactionStatus.fromString(complaint.transaction!.status),
                ),
                theme,
                textTheme,
              ),
            ],
          ),
          SizedBox(height: space * 1.5),
        ],
        // Action Buttons
        if (ComplaintStatusHelper.canUpdate(status)) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isProcessing
                  ? null
                  : () => _showUpdateDialog(complaint),
              icon: const Icon(Icons.edit_outlined),
              label: Text(s.update_complaint),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: space),
                backgroundColor: AppColors.warningUpdate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(space),
                ),
              ),
            ),
          ),
        ],

        if (ComplaintStatusHelper.canReopen(status)) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isProcessing ? null : _showReopenDialog,
              icon: const Icon(Icons.refresh),
              label: Text(s.reopen_complaint),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: space),
                backgroundColor: AppColors.warning,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(space),
                ),
              ),
            ),
          ),
        ],

        SizedBox(height: space * 2),
      ],
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    TextTheme textTheme,
    double space, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(space),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(space),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.primaryColor, size: 20),
              SizedBox(width: space / 2),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: space),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(flex: 3, child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildUserSection(
    String label,
    String name,
    String? phone,
    String? avatarUrl,
    ThemeData theme,
    TextTheme textTheme,
    double space,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: space / 2),
        Row(
          children: [
            CircleAvatar(
              radius: space * 2,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : null,
              backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: space * 2,
                      color: theme.primaryColor,
                    )
                  : null,
            ),
            SizedBox(width: space),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (phone != null) ...[
                    SizedBox(height: space / 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: theme.hintColor),
                        SizedBox(width: space / 4),
                        Text(
                          phone,
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
