import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/enum/transaction_status.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_detail_request.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

/// Bottom action buttons for transaction detail
class TransactionDetailBottomActions extends ConsumerWidget {
  final TransactionEntity transaction;
  final Role userRole;
  final VoidCallback onActionCompleted;

  const TransactionDetailBottomActions({
    super.key,
    required this.transaction,
    required this.userRole,
    required this.onActionCompleted,
  });

  bool get _isHousehold => userRole == Role.household;

  bool get _isCollector =>
      userRole == Role.individualCollector ||
      userRole == Role.businessCollector;

  bool get _canTakeAction {
    final status = transaction.statusEnum;
    return _isHousehold && status == TransactionStatus.inProgress;
  }

  bool get _isCompleted {
    return transaction.statusEnum == TransactionStatus.completed;
  }

  bool get _canToggleCancel {
    return _isCollector &&
        (transaction.statusEnum == TransactionStatus.inProgress ||
            transaction.statusEnum == TransactionStatus.canceledByUser);
  }

  bool get _canCheckIn {
    return _isCollector &&
        transaction.statusEnum == TransactionStatus.scheduled &&
        transaction.checkInTime == null;
  }

  bool get _canInputDetails {
    return _isCollector &&
        transaction.statusEnum == TransactionStatus.inProgress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    // Show review/complain buttons for completed transactions
    if (_isCompleted) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: _CompletedTransactionActions(
            transactionId: transaction.transactionId,
            onActionCompleted: onActionCompleted,
          ),
        ),
      );
    }

    // Show check-in button for collector when Scheduled
    if (_canCheckIn) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: _CheckInButton(
            transaction: transaction,
            onActionCompleted: onActionCompleted,
          ),
        ),
      );
    }

    // Show input details and toggle cancel buttons for collector when InProgress
    if (_canInputDetails || _canToggleCancel) {
      final buttons = <Widget>[];

      // Priority: Input details button (for entering actual scrap quantity)
      if (_canInputDetails) {
        buttons.add(
          Expanded(
            flex: 2,
            child: _InputDetailsButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      // Toggle cancel button (emergency cancel/resume)
      if (_canToggleCancel) {
        if (buttons.isNotEmpty) {
          buttons.add(SizedBox(width: spacing));
        }
        buttons.add(
          Expanded(
            child: _ToggleCancelButton(
              transaction: transaction,
              onActionCompleted: onActionCompleted,
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: buttons.length == 1 ? buttons.first : Row(children: buttons),
        ),
      );
    }

    // Show approve/reject buttons for in-progress transactions (household)
    if (_canTakeAction) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: _RejectButton(
                  transactionId: transaction.transactionId,
                  onActionCompleted: onActionCompleted,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _ApproveButton(
                  transactionId: transaction.transactionId,
                  onActionCompleted: onActionCompleted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // No action buttons to show
    // return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _RejectButton(
                transactionId: transaction.transactionId,
                onActionCompleted: onActionCompleted,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _ApproveButton(
                transactionId: transaction.transactionId,
                onActionCompleted: onActionCompleted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reject/Cancel button
class _RejectButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _RejectButton({
    required this.transactionId,
    required this.onActionCompleted,
  });

  Future<void> _handleCancel(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show confirmation dialog
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.cancel_transaction,
      message: s.cancel_message,
      confirmText: s.cancel_transaction,
      isDestructive: true,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      // Call API to cancel transaction
      await ref
          .read(transactionViewModelProvider.notifier)
          .processTransaction(transactionId: transactionId, isAccepted: false);

      if (context.mounted) {
        CustomToast.show(
          context,
          s.transaction_cancelled,
          type: ToastType.success,
        );
        onActionCompleted();
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return ElevatedButton(
      onPressed: isProcessing ? null : () => _handleCancel(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: AppColors.danger.withValues(alpha: 0.6),
      ),
      child: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.scaffoldBackgroundColor,
                ),
              ),
            )
          : Text(
              s.cancel_transaction,
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

/// Check-in button for collector
class _CheckInButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const _CheckInButton({
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleCheckIn(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;
    // final theme = Theme.of(context);
    // final spacing = theme.extension<AppSpacing>()!.screenPadding;

    // Show check-in dialog with GPS location
    final result = await showDialog<Map<String, double>?>(
      context: context,
      builder: (context) =>
          _CheckInLocationDialog(transactionId: transaction.transactionId),
    );

    if (result == null || !context.mounted) return;

    // Kiểm tra giá trị có tồn tại và không null
    final latitude = result['latitude'];
    final longitude = result['longitude'];
    
    if (latitude == null || longitude == null) {
      if (context.mounted) {
        CustomToast.show(
          context,
          'Không thể lấy vị trí. Vui lòng thử lại.',
          type: ToastType.error,
        );
      }
      return;
    }

    try {
      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .checkInTransaction(
            transactionId: transaction.transactionId,
            latitude: latitude,
            longitude: longitude,
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            s.check_in_success,
            type: ToastType.success,
          );
          onActionCompleted();
        } else {
          final state = ref.read(transactionViewModelProvider);
          final errorMsg = state.errorMessage;

          // Hiển thị message từ API backend nếu có
          if (errorMsg != null && errorMsg.isNotEmpty) {
            CustomToast.show(
              context,
              errorMsg, // Hiển thị message chuẩn từ API
              type: ToastType.error,
            );
          } else {
            CustomToast.show(
              context,
              s.operation_failed,
              type: ToastType.error,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return ElevatedButton.icon(
      onPressed: isProcessing ? null : () => _handleCheckIn(context, ref),
      icon: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.scaffoldBackgroundColor,
                ),
              ),
            )
          : const Icon(Icons.location_on),
      label: Text(
        s.check_in,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Check-in location dialog
class _CheckInLocationDialog extends StatefulWidget {
  final String transactionId;

  const _CheckInLocationDialog({required this.transactionId});

  @override
  State<_CheckInLocationDialog> createState() => _CheckInLocationDialogState();
}

class _CheckInLocationDialogState extends State<_CheckInLocationDialog> {
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use platform channel to get location
      // This is a simple implementation - in production, use geolocator package
      // For now, we'll use a basic approach

      // Try to get location using platform channels
      // Note: This requires location permissions in AndroidManifest.xml and Info.plist
      final location = await _getLocationFromPlatform();

      if (location != null) {
        setState(() {
          _isLoading = false;
          _latitude = location['latitude'];
          _longitude = location['longitude'];
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Không thể lấy vị trí. Vui lòng bật GPS và cấp quyền vị trí.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể lấy vị trí. Vui lòng thử lại.';
      });
    }
  }

  Future<Map<String, double>?> _getLocationFromPlatform() async {
    try {
      // Check location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      title: Row(
        children: [
          Icon(Icons.location_on, color: theme.primaryColor),
          SizedBox(width: spacing),
          Expanded(child: Text(s.check_in)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            )
          else if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.all(spacing),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.danger,
                    size: spacing * 4,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            )
          else if (_latitude != null && _longitude != null)
            Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                  size: spacing * 4,
                ),
                SizedBox(height: spacing),
                Text(
                  'Đã lấy vị trí thành công',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: spacing / 2),
                Text(
                  'Lat: ${_latitude!.toStringAsFixed(6)}, Long: ${_longitude!.toStringAsFixed(6)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          SizedBox(height: spacing),
          Text(
            s.check_in_message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: (_latitude != null && _longitude != null && !_isLoading)
              ? () {
                  // Đảm bảo giá trị không null và trả về Map<String, double> (non-nullable)
                  if (_latitude != null && _longitude != null && context.mounted) {
                    Navigator.of(context).pop<Map<String, double>>({
                      'latitude': _latitude!,
                      'longitude': _longitude!,
                    });
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(s.check_in),
        ),
      ],
    );
  }
}

/// Input details button for collector (enter actual scrap quantity)
class _InputDetailsButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const _InputDetailsButton({
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleInputDetails(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show input details dialog
    final result = await showDialog<List<Map<String, dynamic>>?>(
      context: context,
      builder: (context) => _InputScrapQuantityDialog(transaction: transaction),
    );

    if (result == null || result.isEmpty || !context.mounted) return;

    try {
      // Convert to TransactionDetailRequest list
      final details = result.map((item) {
        return TransactionDetailRequest(
          scrapCategoryId: item['scrapCategoryId'] as int,
          pricePerUnit: item['pricePerUnit'] as double,
          unit: item['unit'] as String,
          quantity: item['quantity'] as double,
        );
      }).toList();

      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .updateTransactionDetails(
            transactionId: transaction.transactionId,
            details: details,
          );

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            'Đã cập nhật số lượng thành công',
            type: ToastType.success,
          );
          onActionCompleted();
        } else {
          final state = ref.read(transactionViewModelProvider);
          final errorMsg = state.errorMessage;

          if (errorMsg != null &&
              (errorMsg.contains('Check-in') ||
                  errorMsg.contains('check-in') ||
                  errorMsg.contains('chưa Check-in'))) {
            CustomToast.show(
              context,
              'Vui lòng check-in trước khi nhập số lượng',
              type: ToastType.error,
            );
          } else if (errorMsg != null &&
              (errorMsg.contains('loại ve chai') ||
                  errorMsg.contains('scrap category'))) {
            CustomToast.show(
              context,
              'Loại ve chai không hợp lệ. Vui lòng kiểm tra lại.',
              type: ToastType.error,
            );
          } else {
            CustomToast.show(
              context,
              s.operation_failed,
              type: ToastType.error,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return ElevatedButton.icon(
      onPressed: isProcessing ? null : () => _handleInputDetails(context, ref),
      icon: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.scaffoldBackgroundColor,
                ),
              ),
            )
          : const Icon(Icons.edit),
      label: Text(
        'Nhập số lượng',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Input scrap quantity dialog
class _InputScrapQuantityDialog extends StatefulWidget {
  final TransactionEntity transaction;

  const _InputScrapQuantityDialog({required this.transaction});

  @override
  State<_InputScrapQuantityDialog> createState() =>
      _InputScrapQuantityDialogState();
}

class _InputScrapQuantityDialogState extends State<_InputScrapQuantityDialog> {
  final Map<int, TextEditingController> _quantityControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each offer detail
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];
    for (final detail in offerDetails) {
      // Pre-fill with existing quantity if available
      final existingDetail = widget.transaction.transactionDetails
          .where((td) => td.scrapCategoryId == detail.scrapCategoryId)
          .firstOrNull;
      _quantityControllers[detail.scrapCategoryId] = TextEditingController(
        text: existingDetail?.quantity.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _getDetails() {
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];
    final details = <Map<String, dynamic>>[];

    for (final detail in offerDetails) {
      final controller = _quantityControllers[detail.scrapCategoryId];
      if (controller != null && controller.text.isNotEmpty) {
        final quantity = double.tryParse(controller.text);
        if (quantity != null && quantity > 0) {
          details.add({
            'scrapCategoryId': detail.scrapCategoryId,
            'pricePerUnit': detail.pricePerUnit,
            'unit': detail.unit,
            'quantity': quantity,
          });
        }
      }
    }

    return details;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;
    final offerDetails = widget.transaction.offer?.offerDetails ?? [];

    if (offerDetails.isEmpty) {
      return AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Text('Không có dữ liệu'),
        content: Text('Không tìm thấy danh sách ve chai để nhập số lượng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing),
      ),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.primaryColor),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              'Nhập số lượng ve chai thực tế',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: AppColors.warningUpdate.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing / 2),
                  border: Border.all(
                    color: AppColors.warningUpdate.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.warningUpdate,
                      size: spacing * 1.5,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        'Sau khi cân đo, nhập số lượng thực tế cho từng loại ve chai. Hệ thống sẽ tự động tính lại tổng tiền.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warningUpdate,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing * 1.5),
              ...offerDetails.map((detail) {
                final controller = _quantityControllers[detail.scrapCategoryId];
                if (controller == null) return const SizedBox.shrink();

                return Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: Container(
                    padding: EdgeInsets.all(spacing),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(spacing / 2),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.recycling,
                              color: theme.primaryColor,
                              size: spacing * 1.5,
                            ),
                            SizedBox(width: spacing / 2),
                            Expanded(
                              child: Text(
                                detail.scrapCategory?.categoryName ??
                                    'Loại ve chai ${detail.scrapCategoryId}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing / 2),
                        Text(
                          'Giá: ${detail.pricePerUnit.toStringAsFixed(0)} ${s.per_unit}/${detail.unit}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        SizedBox(height: spacing),
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Số lượng (${detail.unit})',
                            hintText: 'Nhập số lượng thực tế',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(spacing / 2),
                            ),
                            suffixText: detail.unit,
                            filled: true,
                            fillColor: theme.cardColor,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số lượng';
                            }
                            final quantity = double.tryParse(value);
                            if (quantity == null || quantity < 0) {
                              return 'Số lượng không hợp lệ';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  final details = _getDetails();
                  if (details.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập ít nhất một loại ve chai'),
                        backgroundColor: AppColors.danger,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, details);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Lưu'),
        ),
      ],
    );
  }
}

/// Approve/Complete button
class _ApproveButton extends ConsumerWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _ApproveButton({
    required this.transactionId,
    required this.onActionCompleted,
  });

  Future<void> _handleComplete(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;

    // Show confirmation dialog
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.completed,
      message: s.approve_message,
      confirmText: s.completed,
      isDestructive: false,
    );

    if (confirmed != true || !context.mounted) return;

    try {
      // Call API to complete transaction
      await ref
          .read(transactionViewModelProvider.notifier)
          .processTransaction(transactionId: transactionId, isAccepted: true);

      if (context.mounted) {
        CustomToast.show(
          context,
          s.transaction_approved,
          type: ToastType.success,
        );
        onActionCompleted();
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return ElevatedButton(
      onPressed: isProcessing ? null : () => _handleComplete(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: theme.primaryColor.withValues(alpha: 0.6),
      ),
      child: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.scaffoldBackgroundColor,
                ),
              ),
            )
          : Text(
              s.completed,
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

/// Toggle cancel button for collector (emergency cancel/resume)
class _ToggleCancelButton extends ConsumerWidget {
  final TransactionEntity transaction;
  final VoidCallback onActionCompleted;

  const _ToggleCancelButton({
    required this.transaction,
    required this.onActionCompleted,
  });

  Future<void> _handleToggleCancel(BuildContext context, WidgetRef ref) async {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;

    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing),
        ),
        title: Row(
          children: [
            Icon(
              isCanceled ? Icons.restart_alt : Icons.warning_amber_rounded,
              color: isCanceled ? AppColors.warningUpdate : AppColors.danger,
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Text(
                isCanceled ? s.resume_transaction : s.emergency_cancel,
                style: TextStyle(
                  color: isCanceled
                      ? AppColors.warningUpdate
                      : AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCanceled ? s.resume_message : s.emergency_cancel_message),
            if (!isCanceled) ...[
              SizedBox(height: spacing),
              Container(
                padding: EdgeInsets.all(spacing),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(spacing / 2),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.danger,
                      size: spacing * 1.5,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        s.emergency_cancel_note,
                        style:  TextStyle(
                          fontSize: 12,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCanceled
                  ? AppColors.warningUpdate
                  : AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: Text(isCanceled ? s.resume : s.emergency_cancel),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final success = await ref
          .read(transactionViewModelProvider.notifier)
          .toggleCancelTransaction(transaction.transactionId);

      if (context.mounted) {
        if (success) {
          CustomToast.show(
            context,
            isCanceled
                ? s.transaction_resumed
                : s.transaction_emergency_canceled,
            type: ToastType.success,
          );
          onActionCompleted();
        } else {
          CustomToast.show(context, s.operation_failed, type: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context)!;
    final isCanceled =
        transaction.statusEnum == TransactionStatus.canceledByUser;
    final state = ref.watch(transactionViewModelProvider);
    final isProcessing = state.isProcessing;

    return OutlinedButton.icon(
      onPressed: isProcessing ? null : () => _handleToggleCancel(context, ref),
      icon: isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCanceled ? AppColors.warningUpdate : AppColors.danger,
                ),
              ),
            )
          : Icon(isCanceled ? Icons.restart_alt : Icons.warning_amber_rounded),
      label: Text(
        isCanceled ? s.resume_transaction : s.emergency_cancel,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(
          color: isCanceled ? AppColors.warningUpdate : AppColors.danger,
          width: 2,
        ),
        foregroundColor: isCanceled
            ? AppColors.warningUpdate
            : AppColors.danger,
        backgroundColor: isCanceled
            ? AppColors.warningUpdate.withValues(alpha: 0.05)
            : AppColors.danger.withValues(alpha: 0.05),
        disabledForegroundColor: isCanceled
            ? AppColors.warningUpdate
            : AppColors.danger,
        disabledBackgroundColor: isCanceled
            ? AppColors.warningUpdate.withValues(alpha: 0.05)
            : AppColors.danger.withValues(alpha: 0.05),
      ),
    );
  }
}

/// Action buttons for completed transactions
class _CompletedTransactionActions extends StatelessWidget {
  final String transactionId;
  final VoidCallback onActionCompleted;

  const _CompletedTransactionActions({
    required this.transactionId,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Row(
      children: [
        // Review button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-feedback',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.star, size: spacing * 1.8),
            label: Text(s.write_review),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: spacing),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        // Complain button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed<bool>(
                'create-complaint',
                extra: {'transactionId': transactionId},
              );
              if (result == true) {
                onActionCompleted();
              }
            },
            icon: Icon(Icons.report_problem, size: spacing * 1.8),
            label: Text(s.complain),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: spacing),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
