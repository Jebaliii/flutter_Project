import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../models/booking.dart';
import '../../models/hotel.dart';
import '../../services/booking_service.dart';
import '../../services/hotel_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animations.dart';
import '../../widgets/app_feedback.dart';
import 'admin_common.dart';
import 'admin_shell.dart';

/// Key figures + latest bookings.
class AdminDashboardTab extends StatefulWidget {
  final ValueChanged<AdminTab> onOpen;

  const AdminDashboardTab({super.key, required this.onOpen});

  @override
  State<AdminDashboardTab> createState() => _AdminDashboardTabState();
}

class _AdminDashboardTabState extends State<AdminDashboardTab> {
  late Stream<List<Booking>> _bookings = BookingService().watchAll();
  late Stream<List<Hotel>> _hotels = HotelService().watchAll();
  late Stream<List<AppUser>> _users = UserService().watchAll();

  void _retry() => setState(() {
    _bookings = BookingService().watchAll();
    _hotels = HotelService().watchAll();
    _users = UserService().watchAll();
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return StreamBuilder<List<Booking>>(
      stream: _bookings,
      builder: (context, bSnap) => StreamBuilder<List<Hotel>>(
        stream: _hotels,
        builder: (context, hSnap) => StreamBuilder<List<AppUser>>(
          stream: _users,
          builder: (context, uSnap) {
            final error = bSnap.error ?? hSnap.error ?? uSnap.error;
            if (error != null) {
              return Center(
                child: StateMessage.error(
                  context,
                  error: error,
                  onRetry: _retry,
                ),
              );
            }
            if (!bSnap.hasData || !hSnap.hasData || !uSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final bookings = bSnap.data!;
            final revenue = bookings
                .where((b) => b.status == 'confirmed')
                .fold<int>(0, (sum, b) => sum + b.total);
            final pending = bookings.where((b) => b.status == 'pending');

            final stats = [
              (
                Icons.people,
                const Color(0xFF8B5CF6),
                '${uSnap.data!.length}',
                l.adminUsers,
                AdminTab.users,
              ),
              (
                Icons.hotel,
                const Color(0xFF3B82F6),
                '${hSnap.data!.length}',
                l.adminHotels,
                AdminTab.hotels,
              ),
              (
                Icons.book_online,
                const Color(0xFF0EA5E9),
                '${bookings.length}',
                l.adminBookings,
                AdminTab.bookings,
              ),
              (
                Icons.hourglass_bottom,
                const Color(0xFFF59E0B),
                '${pending.length}',
                l.pendingPlural,
                AdminTab.bookings,
              ),
            ];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FadeSlideIn(child: _RevenueCard(revenue: revenue)),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, c) {
                    final cols = c.maxWidth >= 640 ? 4 : 2;
                    final w = (c.maxWidth - (cols - 1) * 12) / cols;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final (i, (icon, color, value, label, tab))
                            in stats.indexed)
                          FadeSlideIn(
                            delay: Duration(milliseconds: 60 * (i + 1)),
                            child: SizedBox(
                              width: w,
                              child: _StatTile(
                                icon: icon,
                                color: color,
                                value: value,
                                label: label,
                                onTap: () => widget.onOpen(tab),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l.recentBookings,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (bookings.isEmpty)
                  StateMessage(icon: Icons.event_busy, title: l.noBookings)
                else
                  Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        for (final b in bookings.take(5))
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: statusColor(b.status)
                                  .withValues(alpha: 0.15),
                              child: Icon(
                                Icons.hotel,
                                color: statusColor(b.status),
                              ),
                            ),
                            title: Text(b.hotelName),
                            subtitle: Text(
                              b.userEmail,
                              textDirection: TextDirection.ltr,
                            ),
                            trailing: StatusBadge(
                              statusLabel(l, b.status),
                              statusColor(b.status),
                            ),
                            onTap: () => widget.onOpen(AdminTab.bookings),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final int revenue;

  const _RevenueCard({required this.revenue});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.revenue, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  l.amountTnd('$revenue'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    ),
  );
}
