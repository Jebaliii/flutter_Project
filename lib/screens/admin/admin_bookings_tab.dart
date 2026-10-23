import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_feedback.dart';
import 'admin_common.dart';

/// All bookings: filter, search, change status, delete.
class AdminBookingsTab extends StatefulWidget {
  const AdminBookingsTab({super.key});

  @override
  State<AdminBookingsTab> createState() => _AdminBookingsTabState();
}

class _AdminBookingsTabState extends State<AdminBookingsTab> {
  final _service = BookingService();
  late Stream<List<Booking>> _bookings = _service.watchAll();

  String _filter = 'all'; // all | confirmed | pending | cancelled
  String _query = '';

  void _retry() => setState(() => _bookings = _service.watchAll());

  Future<void> _setStatus(Booking b, String status) => runAdminAction(
    context,
    () => _service.setStatus(b.id, status),
    context.l10n.bookingUpdated,
  );

  Future<void> _delete(Booking b) async {
    final l = context.l10n;
    if (!await confirmDelete(context, b.hotelName)) return;
    if (!mounted) return;
    await runAdminAction(
      context,
      () => _service.delete(b.id),
      l.bookingDeleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return StreamBuilder<List<Booking>>(
      stream: _bookings,
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

        final all = snap.data!;
        int count(String s) => all.where((b) => b.status == s).length;
        final q = _query.trim().toLowerCase();
        final filtered = all.where((b) {
          final okStatus = _filter == 'all' || b.status == _filter;
          final okQuery =
              q.isEmpty ||
              b.hotelName.toLowerCase().contains(q) ||
              b.city.toLowerCase().contains(q) ||
              b.userEmail.toLowerCase().contains(q);
          return okStatus && okQuery;
        }).toList();

        Widget chip(String key, String label) => Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: _filter == key,
            onSelected: (_) => setState(() => _filter = key),
          ),
        );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: AdminSearchField(
                hint: l.searchBookingsHint,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  chip('all', l.filterAll(all.length)),
                  chip('confirmed', l.filterConfirmed(count('confirmed'))),
                  chip('pending', l.filterPending(count('pending'))),
                  chip('cancelled', l.filterCancelled(count('cancelled'))),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: StateMessage(
                        icon: all.isEmpty ? Icons.event_busy : Icons.search_off,
                        title: l.noBookings,
                        message: all.isEmpty ? null : l.noResultsForFilter,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => _card(filtered[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _card(Booking b) {
    final l = context.l10n;
    final muted = TextStyle(color: context.colors.onSurfaceVariant);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          b.hotelName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        statusLabel(l, b.status),
                        statusColor(b.status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: muted.color),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          b.userEmail,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l.dateRange(fmtDate(b.arrival), fmtDate(b.departure))}'
                    ' · ${l.nightsCount(b.nights)}',
                    style: muted,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${l.amountTnd('${b.total}')} · '
                    '${b.paymentMethod == 'online' ? l.online : l.cash}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (action) =>
                  action == 'delete' ? _delete(b) : _setStatus(b, action),
              itemBuilder: (_) => [
                if (b.status != 'confirmed')
                  PopupMenuItem(
                    value: 'confirmed',
                    child: menuRow(Icons.check_circle, l.markConfirmed),
                  ),
                if (b.status != 'pending')
                  PopupMenuItem(
                    value: 'pending',
                    child: menuRow(Icons.hourglass_bottom, l.markPending),
                  ),
                if (b.status != 'cancelled')
                  PopupMenuItem(
                    value: 'cancelled',
                    child: menuRow(Icons.cancel, l.markCancelled),
                  ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: menuRow(
                    Icons.delete,
                    l.delete,
                    color: context.colors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
