import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../widgets/app_feedback.dart';

String fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/${d.year}';

String statusLabel(AppLocalizations l, String status) => switch (status) {
  'confirmed' => l.statusConfirmed,
  'pending' => l.statusPending,
  _ => l.statusCancelled,
};

Color statusColor(String status) => switch (status) {
  'confirmed' => const Color(0xFF10B981),
  'pending' => const Color(0xFFF59E0B),
  _ => const Color(0xFFEF4444),
};

/// Small colored label (booking status, user role...).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );
}

/// "Delete X?" dialog. Returns true when confirmed.
Future<bool> confirmDelete(BuildContext context, String name) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.deleteQuestion(name)),
      content: Text(l.irreversible),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return ok == true;
}

/// Runs an admin action and shows a success or error SnackBar.
Future<void> runAdminAction(
  BuildContext context,
  Future<void> Function() action,
  String success,
) async {
  try {
    await action();
    if (context.mounted) context.showSuccess(success);
  } catch (e) {
    if (context.mounted) context.showError(e);
  }
}

/// Search field used at the top of the admin lists.
class AdminSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const AdminSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: hint,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// Icon + label row used in the admin popup menus.
Widget menuRow(IconData icon, String label, {Color? color}) => Row(
  children: [
    Icon(icon, size: 20, color: color),
    const SizedBox(width: 12),
    Text(label, style: TextStyle(color: color)),
  ],
);
