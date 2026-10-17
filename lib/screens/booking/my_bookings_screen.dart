import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/language_menu_button.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _service = BookingService();
  final _searchCtrl = TextEditingController();

  String _filter = 'all'; // all | confirmed | pending | cancelled
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _fmtTime(DateTime d) => context.l10n.dateAtTime(_fmt(d),
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}');

  void _backToMap() => Navigator.of(context).popUntil((r) => r.isFirst);

  Future<void> _cancel(Booking b) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cancelBookingQuestion),
        content: Text(
            '${b.hotelName}\n${l.dateRange(_fmt(b.arrival), _fmt(b.departure))}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.no)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.yesCancel)),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _service.cancel(b.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.bookingCancelled)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(
              SnackBar(content: Text(l.errorWithMessage(localizeError(l, e)))));
    }
  }

  void _details(Booking b) {
    final l = context.l10n;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(b.hotelName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l.cityTunisia(b.city),
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            _line(l.reference, b.id),
            _line(l.arrival, _fmt(b.arrival)),
            _line(l.departure, _fmt(b.departure)),
            _line(l.duration, l.nightsCount(b.nights)),
            _line(l.payment, b.paymentMethod == 'online' ? l.online : l.cash),
            _line(l.status, _statusLabel(b.status)),
            _line(l.total, l.amountTnd('${b.total}')),
          ],
        ),
      ),
    );
  }

  Widget _line(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: const TextStyle(color: Colors.black54)),
            const SizedBox(width: 12),
            Flexible(
                child: Text(v,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );

  String _statusLabel(String s) => switch (s) {
        'confirmed' => context.l10n.statusConfirmed,
        'pending' => context.l10n.statusPending,
        _ => context.l10n.statusCancelled,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: StreamBuilder<List<Booking>>(
        stream: _service.watchMine(),
        builder: (context, snap) {
          final all = snap.data ?? [];
          final confirmed = all.where((b) => b.status == 'confirmed').length;
          final pending = all.where((b) => b.status == 'pending').length;
          final cancelled = all.where((b) => b.status == 'cancelled').length;

          final filtered = all.where((b) {
            final okStatus = _filter == 'all' || b.status == _filter;
            final q = _query.trim().toLowerCase();
            final okQuery = q.isEmpty ||
                b.hotelName.toLowerCase().contains(q) ||
                b.city.toLowerCase().contains(q);
            return okStatus && okQuery;
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                _header(),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _stats(all.length, confirmed, pending),
                          const SizedBox(height: 16),
                          _filters(all.length, confirmed, pending, cancelled),
                          const SizedBox(height: 16),
                          if (snap.hasError)
                            _message(Icons.error_outline,
                                l.loadingError, '${snap.error}')
                          else if (snap.connectionState ==
                                  ConnectionState.waiting &&
                              !snap.hasData)
                            const Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            )
                          else if (filtered.isEmpty)
                            _message(
                                Icons.event_busy,
                                l.noBookings,
                                all.isEmpty
                                    ? l.noBookingsYet
                                    : l.noResultsForFilter)
                          else
                            LayoutBuilder(builder: (context, c) {
                              final cols = c.maxWidth >= 640 ? 2 : 1;
                              final w = (c.maxWidth - (cols - 1) * 16) / cols;
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: filtered
                                    .map((b) => SizedBox(width: w, child: _card(b)))
                                    .toList(),
                              );
                            }),
                          const SizedBox(height: 24),
                          OutlinedButton(
                            onPressed: _backToMap,
                            child: Text(l.backToMap),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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

  Widget _header() {
    final l = context.l10n;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.myBookings,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(l.myBookingsSubtitle,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const LanguageMenuButton(color: Colors.white),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _backToMap,
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white)),
                child: Text(l.newBooking),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats(int total, int confirmed, int pending) {
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
            child: _StatCard(Icons.book_online, const Color(0xFF3B82F6),
                '$total', l.totalBookings)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(Icons.check_circle, const Color(0xFF10B981),
                '$confirmed', l.confirmedPlural)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(Icons.hourglass_bottom, const Color(0xFFF59E0B),
                '$pending', l.pendingPlural)),
      ],
    );
  }

  Widget _filters(int all, int confirmed, int pending, int cancelled) {
    final l = context.l10n;
    Widget chip(String key, String label) => ChoiceChip(
          label: Text(label),
          selected: _filter == key,
          onSelected: (_) => setState(() => _filter = key),
        );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.filterByStatus,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                chip('all', l.filterAll(all)),
                chip('confirmed', l.filterConfirmed(confirmed)),
                chip('pending', l.filterPending(pending)),
                chip('cancelled', l.filterCancelled(cancelled)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l.searchHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _message(IconData icon, String title, String sub) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(icon, size: 56, color: Colors.black38),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(sub,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      );

  Widget _card(Booking b) {
    final l = context.l10n;
    final (bg, fg) = switch (b.status) {
      'confirmed' => (const Color(0xFFD1FAE5), const Color(0xFF047857)),
      'pending' => (const Color(0xFFFEF3C7), const Color(0xFFB45309)),
      _ => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
    };
    final online = b.paymentMethod == 'online';
    final canCancel = b.status != 'cancelled';

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.hotelName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(l.cityTunisia(b.city),
                          style: const TextStyle(
                              color: Color(0xFF2563EB), fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: bg, borderRadius: BorderRadius.circular(10)),
                  child: Text(_statusLabel(b.status).toUpperCase(),
                      style: TextStyle(
                          color: fg,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _line(l.arrival, _fmt(b.arrival)),
                _line(l.departure, _fmt(b.departure)),
                _line(l.duration, l.nightsCount(b.nights)),
                _line(l.pricePerNight, l.amountTnd('${b.pricePerNight}.00')),
                _line(l.paymentMethod,
                    (online ? l.online : l.cash).toUpperCase()),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l.totalAmount,
                        style: const TextStyle(color: Colors.black54)),
                    Text(l.amountTnd('${b.total}'),
                        style: const TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    b.createdAt == null
                        ? ''
                        : l.bookedOn(_fmtTime(b.createdAt!)),
                    style: const TextStyle(color: Colors.black45, fontSize: 11),
                  ),
                ),
                FilledButton(
                    onPressed: () => _details(b),
                    child: Text(l.details)),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: canCancel ? () => _cancel(b) : null,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(
                          color: canCancel ? Colors.red : Colors.black12)),
                  child: Text(l.cancel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _StatCard(this.icon, this.color, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}