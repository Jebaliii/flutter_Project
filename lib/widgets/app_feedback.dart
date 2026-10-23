import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

enum FeedbackType { success, error, info }

/// Consistent SnackBars across the app (colour + icon by type).
extension FeedbackX on BuildContext {
  void showSnack(String message, {FeedbackType type = FeedbackType.info}) {
    final (bg, icon) = switch (type) {
      FeedbackType.success => (const Color(0xFF047857), Icons.check_circle),
      FeedbackType.error => (const Color(0xFFB91C1C), Icons.error_outline),
      FeedbackType.info => (const Color(0xFF334155), Icons.info_outline),
    };
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: bg,
          duration: Duration(seconds: type == FeedbackType.error ? 4 : 3),
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void showSuccess(String message) =>
      showSnack(message, type: FeedbackType.success);

  /// Shows the translated message of a service error.
  void showError(Object error) => showSnack(
    error is String ? error : localizeError(l10n, error),
    type: FeedbackType.error,
  );
}

/// Small spinner used inside buttons while an action is running.
class ButtonSpinner extends StatelessWidget {
  final Color? color;

  const ButtonSpinner({super.key, this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(strokeWidth: 2, color: color),
  );
}

/// Centered message for empty and error states, with an optional action
/// (e.g. "Retry").
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final bool isError;

  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon = Icons.refresh,
    this.onAction,
    this.isError = false,
  });

  /// Error state with a "Retry" button.
  factory StateMessage.error(
    BuildContext context, {
    Key? key,
    required Object error,
    required VoidCallback onRetry,
  }) {
    final l = context.l10n;
    return StateMessage(
      key: key,
      icon: Icons.cloud_off,
      title: l.loadingError,
      message: localizeError(l, error),
      actionLabel: l.retry,
      onAction: onRetry,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: isError ? colors.error : colors.outline),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onAction,
              icon: Icon(actionIcon),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
