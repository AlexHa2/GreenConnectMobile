import 'package:GreenConnectMobile/core/di/profile_injector.dart';
import 'package:GreenConnectMobile/core/enum/role.dart';
import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/widgets/offer_detail/confirm_dialog_helper.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setting.dart';
import 'package:GreenConnectMobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/providers/transaction_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QRCodePaymentPage extends ConsumerStatefulWidget {
  final String transactionId;
  final TransactionEntity? transaction;
  final VoidCallback onActionCompleted;
  final bool showActionButtons; // If false: hide "Complete" button, only show back to transaction list button
  final Role? userRole; // User role to navigate to correct transaction list page
  final double? amountDifference; // Amount difference to use for QR code generation

  const QRCodePaymentPage({
    super.key,
    required this.transactionId,
    this.transaction,
    required this.onActionCompleted,
    this.showActionButtons = true, // Default true to maintain backward compatibility
    this.userRole,
    this.amountDifference,
  });

  @override
  ConsumerState<QRCodePaymentPage> createState() => _QRCodePaymentPageState();
}

class _QRCodePaymentPageState extends ConsumerState<QRCodePaymentPage> {
  String? _qrCodeUrl;
  bool _isLoadingQR = true;
  String? _errorMessage;
  bool _isProcessing = false;
  Role? _userRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRole();
      _loadQRCode();
    });
  }

  Future<void> _loadUserRole() async {
    final tokenStorage = sl<TokenStorageService>();
    final user = await tokenStorage.getUserData();
    if (user != null && user.roles.isNotEmpty) {
      setState(() {
        if (Role.hasRole(user.roles, Role.household)) {
          _userRole = Role.household;
        } else if (Role.hasRole(user.roles, Role.individualCollector)) {
          _userRole = Role.individualCollector;
        } else if (Role.hasRole(user.roles, Role.businessCollector)) {
          _userRole = Role.businessCollector;
        }
      });
    } else if (widget.userRole != null) {
      // Use provided role if available
      setState(() {
        _userRole = widget.userRole;
      });
    }
  }

  void _navigateToTransactionList() {
    if (!mounted) return;

    // Use provided role or loaded role
    final role = widget.userRole ?? _userRole;

    if (role == null) {
      // Fallback: just pop if role is not available
      if (context.canPop()) {
        context.pop();
      }
      return;
    }

    // Navigate to the correct list page based on user role
    String targetRoute;
    if (role == Role.household) {
      targetRoute = '/household-list-transactions';
    } else if (role == Role.individualCollector ||
        role == Role.businessCollector) {
      targetRoute = '/collector-list-transactions';
    } else {
      // Fallback: just pop
      if (context.canPop()) {
        context.pop();
      }
      return;
    }

    if (mounted) {
      context.go(targetRoute);
    }
  }

  Future<void> _loadQRCode() async {
    if (!mounted) return;

    setState(() {
      _isLoadingQR = true;
      _errorMessage = null;
    });

    try {
      // Use amountDifference if provided, otherwise fallback to transaction.totalPrice
      double totalAmount;
      
      if (widget.amountDifference != null) {
        // Use amountDifference (absolute value for payment amount)
        totalAmount = widget.amountDifference!.abs();
      } else {
        // Fallback: Get transaction to extract totalPrice
        TransactionEntity? transaction = widget.transaction;
        if (transaction == null) {
          final state = ref.read(transactionViewModelProvider);
          transaction = state.detailData;
        }
        
        if (transaction == null) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Transaction not found';
              _isLoadingQR = false;
            });
          }
          return;
        }
        
        totalAmount = transaction.totalPrice;
      }

      final viewModel = ref.read(transactionViewModelProvider.notifier);
      final qrCode = await viewModel.getTransactionQRCode(
        widget.transactionId,
        totalAmount,
      );

      if (mounted) {
        setState(() {
          _qrCodeUrl = qrCode;
          _isLoadingQR = false;
        });
        
        // If QR code loaded successfully after coming back from bank settings,
        // refresh transaction data in parent page
        // This ensures transaction detail page shows updated data
        if (qrCode != null && qrCode.isNotEmpty) {

          widget.onActionCompleted();
        }
      }
    } catch (e) {

      // Log detailed error info if it's AppException
      if (e is AppException) {
        debugPrint('📌 Status Code: ${e.statusCode}');
        debugPrint('📌 Message: ${e.message}');
      }

      // Check error message for bank-related keywords
      final errorMsg = e.toString().toLowerCase();
      final isBankRelated =
          errorMsg.contains('ngân hàng') ||
          errorMsg.contains('bank') ||
          errorMsg.contains('tài khoản') ||
          errorMsg.contains('account');

      // Priority 1: Check for status code 400 (Bad Request)
      // This is the most reliable indicator
      if (e is BusinessException && e.statusCode == 400) {
        debugPrint('💳 Status 400 - Bank info required');
        if (mounted) {
          setState(() {
            _errorMessage = 'BANK_INFO_REQUIRED';
            _isLoadingQR = false;
          });
        }
        return;
      }

      // Priority 2: Check for bank-related message in BusinessException
      // Fallback if statusCode is null for some reason
      if (e is BusinessException && isBankRelated) {
        if (mounted) {
          setState(() {
            _errorMessage = 'BANK_INFO_REQUIRED';
            _isLoadingQR = false;
          });
        }
        return;
      }

      // Priority 3: Any other BusinessException (404, 409, etc.)
      // Could be other bank-related issues
      if (e is BusinessException) {
        if (mounted) {
          setState(() {
            _errorMessage = 'BANK_INFO_REQUIRED';
            _isLoadingQR = false;
          });
        }
        return;
      }

      // Priority 4: UnauthorizedException
      if (e is UnauthorizedException) {
        if (mounted) {
          setState(() {
            _errorMessage = 'BANK_INFO_REQUIRED';
            _isLoadingQR = false;
          });
        }
        return;
      }

      // Priority 5: Other errors (ServerException, NetworkException, etc.)
      // Show generic error UI with retry button
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoadingQR = false;
        });
      }
    }
  }

  void _navigateToBankSettings() async {
    // Use Navigator.push instead of context.push to avoid GoRouter navigator conflicts
    // This creates a separate navigation stack that doesn't interfere with GoRouter's keys
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileSetting(
          key: ValueKey('qr-profile'),
          haveLayout: false,
        ),
      ),
    );

    // When user comes back, automatically reload QR code
    // This will check if bank info has been updated successfully
    if (mounted) {
      // Use addPostFrameCallback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadQRCode();
        }
      });
    }
  }

  Future<void> _handleComplete() async {
    final s = S.of(context)!;

    // Show confirmation dialog
    final confirmed = await ConfirmDialogHelper.show(
      context: context,
      title: s.confirm_payment,
      message: s.transfer_complete_prompt,
      confirmText: s.completed,
      isDestructive: false,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);

    try {
      // Get transaction data from widget or state
      TransactionEntity? transaction = widget.transaction;
      if (transaction == null) {
        final state = ref.read(transactionViewModelProvider);
        transaction = state.detailData;
      }
      
      if (transaction == null) {
        if (mounted) {
          setState(() => _isProcessing = false);
          CustomToast.show(context, s.operation_failed, type: ToastType.error);
        }
        return;
      }

      // Get required parameters
      final scrapPostId = transaction.offer?.scrapPostId ?? '';
      final collectorId = transaction.scrapCollectorId;
      final slotId = transaction.timeSlotId ?? transaction.offer?.timeSlotId ?? '';
      
      if (scrapPostId.isEmpty || collectorId.isEmpty || slotId.isEmpty) {
        if (mounted) {
          setState(() => _isProcessing = false);
          CustomToast.show(context, s.operation_failed, type: ToastType.error);
        }
        return;
      }

      // Call API to complete transaction with bank transfer
      await ref
          .read(transactionViewModelProvider.notifier)
          .processTransaction(
            scrapPostId: scrapPostId,
            collectorId: collectorId,
            slotId: slotId,
            transactionId: widget.transactionId,
            isAccepted: true,
            paymentMethod: 'BankTransfer',
          );

      if (mounted) {
        CustomToast.show(
          context,
          s.transaction_approved,
          type: ToastType.success,
        );
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        CustomToast.show(context, s.operation_failed, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.qr_payment_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.showActionButtons
              ? () => Navigator.of(context).pop(false)
              : _navigateToTransactionList,
        ),
      ),
      body: _isLoadingQR
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(s.loading_qr_code),
                ],
              ),
            )
          : _errorMessage != null
          ? _errorMessage == 'BANK_INFO_REQUIRED'
                ? _buildBankInfoRequiredUI(theme, spacing)
                : _buildGenericErrorUI(theme, spacing, s)
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(spacing),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - spacing * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          s.scan_qr_to_pay,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.use_banking_app,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // QR Code Image
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _qrCodeUrl != null
                              ? Image.network(
                                  _qrCodeUrl!,
                                  width: 240,
                                  height: 240,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return SizedBox(
                                          width: 240,
                                          height: 240,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('❌ QR IMAGE ERROR: $error');
                                    return SizedBox(
                                      width: 240,
                                      height: 240,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: AppColors.danger,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(s.cannot_load_qr_image),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : SizedBox(
                                  width: 240,
                                  height: 240,
                                  child: Center(child: Text(s.no_qr_code)),
                                ),
                        ),
                        const SizedBox(height: 20),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: theme.primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    s.instructions_title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInstruction(
                                '1',
                                s.instruction_open_banking_app,
                                theme,
                              ),
                              _buildInstruction(
                                '2',
                                s.instruction_scan_qr,
                                theme,
                              ),
                              _buildInstruction(
                                '3',
                                s.instruction_scan_qr,
                                theme,
                              ),
                              _buildInstruction(
                                '4',
                                s.instruction_complete_payment,
                                theme,
                              ),
                              _buildInstruction(
                                '5',
                                s.instruction_confirm,
                                theme,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Complete button - only show when showActionButtons = true
                        if (widget.showActionButtons) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isProcessing ? null : _handleComplete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: theme.primaryColor
                                    .withValues(alpha: 0.6),
                              ),
                              child: _isProcessing
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInstruction(String number, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }

  /// Build UI when bank info is required
  Widget _buildBankInfoRequiredUI(ThemeData theme, double spacing) {
    final s = S.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Friendly icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.warningUpdate.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: AppColors.warningUpdate,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              s.bank_info_needed,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              s.bank_info_needed_description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Info card with steps
            Container(
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.info_to_update,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(s.bank_account_number_list, theme),
                  _buildInfoItem(s.account_holder_name_list, theme),
                  _buildInfoItem(s.bank_name, theme),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Column(
              children: [
                // Primary action - Navigate to settings
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _navigateToBankSettings,
                    icon: const Icon(Icons.settings),
                    label: Text(
                      s.update_now,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Secondary action - Go back
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.showActionButtons
                        ? () => Navigator.of(context).pop(false)
                        : _navigateToTransactionList,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build UI for generic errors (500, network, etc.)
  Widget _buildGenericErrorUI(ThemeData theme, double spacing, S s) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(
              s.cannot_load_qr_code,

              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? s.generic_error_message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadQRCode,
              icon: const Icon(Icons.refresh),
              label: Text(
                s.retry,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
