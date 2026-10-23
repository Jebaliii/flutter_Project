import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_feedback.dart';
import 'admin_common.dart';

/// Users: promote / demote admins, block / unblock accounts.
class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  final _service = UserService();
  late Stream<List<AppUser>> _users = _service.watchAll();
  String _query = '';

  void _retry() => setState(() => _users = _service.watchAll());

  Future<void> _toggleAdmin(AppUser u) => runAdminAction(
    context,
    () => _service.setRole(u.uid, u.isAdmin ? 'user' : 'admin'),
    context.l10n.userUpdated,
  );

  Future<void> _toggleBlocked(AppUser u) => runAdminAction(
    context,
    () => _service.setDisabled(u.uid, !u.disabled),
    context.l10n.userUpdated,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<List<AppUser>>(
      stream: _users,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: StateMessage.error(
              context,
              error: snap.error!,
              onRetry: _retry,
            ),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final q = _query.trim().toLowerCase();
        final users = snap.data!
            .where((u) => q.isEmpty || u.email.toLowerCase().contains(q))
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: AdminSearchField(
                hint: l.searchUsersHint,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? Center(
                      child: StateMessage(
                        icon: Icons.person_off,
                        title: l.noUsers,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: users.length,
                      itemBuilder: (context, i) =>
                          _tile(users[i], isMe: users[i].uid == myUid),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(AppUser u, {required bool isMe}) {
    final l = context.l10n;
    final roleColor = u.isAdmin
        ? const Color(0xFF8B5CF6)
        : const Color(0xFF3B82F6);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: roleColor.withValues(alpha: 0.15),
          foregroundColor: roleColor,
          child: Icon(u.isAdmin ? Icons.admin_panel_settings : Icons.person),
        ),
        title: Text(
          isMe ? '${u.email} ${l.you}' : u.email,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              StatusBadge(u.isAdmin ? l.roleAdmin : l.roleUser, roleColor),
              if (u.disabled) StatusBadge(l.blocked, context.colors.error),
              if (u.createdAt != null)
                Text(
                  fmtDate(u.createdAt!),
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
            ],
          ),
        ),
        // An admin cannot demote or block their own account.
        trailing: isMe
            ? null
            : PopupMenuButton<String>(
                onSelected: (a) =>
                    a == 'role' ? _toggleAdmin(u) : _toggleBlocked(u),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'role',
                    child: menuRow(
                      u.isAdmin ? Icons.person : Icons.admin_panel_settings,
                      u.isAdmin ? l.removeAdmin : l.makeAdmin,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'block',
                    child: menuRow(
                      u.disabled ? Icons.lock_open : Icons.block,
                      u.disabled ? l.unblockUser : l.blockUser,
                      color: u.disabled ? null : context.colors.error,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
