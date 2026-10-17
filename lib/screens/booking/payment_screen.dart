import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../services/booking_service.dart';
import '../../widgets/language_menu_button.dart';
import 'card_payment_screen.dart';
import 'my_bookings_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Hotel hotel;
  final DateTime arrival;
  final DateTime departure;

  const PaymentScreen({
    super.key,
    required this.hotel,
    required this.arrival,
    required this.departure,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _green = Color(0xFF10B981);
  static const _greenDark = Color(0xFF059669);
  static const _blue = Color(0xFF3B82F6);

  final _bookingService = BookingService();

  String? method; // 'online' | 'cash'
  bool accepted = false;
  bool loading = false;
  bool showErrors = false;

  int get nights => widget.departure.difference(widget.arrival).inDays;
  int get total => nights * widget.hotel.pricePerNight;

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _confirm() async {
    final l = context.l10n;
    setState(() => showErrors = true);

    if (method == null) {
      _snack(l.pleaseChoosePaymentMethod);
      return;
    }
    if (!accepted) {
      _snack(l.mustAcceptTermsFull);
      return;
    }

    if (method == 'online') {
      final paid = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => CardPaymentScreen(
            hotel: widget.hotel,
            arrival: widget.arrival,
            departure: widget.departure,
            amount: total,
          ),
        ),
      );
      if (!mounted) return;
      if (paid != true) {
        _snack(l.paymentCancelled);
        return;
      }
    }

    setState(() => loading = true);
    try {
      await _bookingService.create(
        hotel: widget.hotel,
        arrival: widget.arrival,
        departure: widget.departure,
        paymentMethod: method!,
      );
      // TODO Phase 7: push notification de confirmation.
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      _snack(l.saveError(localizeError(l, e)));
      return;
    }
    if (!mounted) return;
    setState(() => loading = false);

    // Go to "Mes Réservations", keeping the map as the root route.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
      (route) => route.isFirst,
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = widget.hotel;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        title: Text(l.appName),
        backgroundColor: const Color(0xFF212529),
        foregroundColor: Colors.white,
        actions: const [LanguageMenuButton()],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: const _PaymentStepper(current: 4),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Card(
                    elevation: 6,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 28, horizontal: 20),
                          decoration: const BoxDecoration(
                            gradient:
                                LinearGradient(colors: [_greenDark, _green]),
                          ),
                          child: Column(
                            children: [
                              Text(l.finalizeBooking,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(l.finalizeBookingSubtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F4FD),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(h.name,
                                      style: const TextStyle(
                                          color: Color(0xFF0B5CAD),
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l.bookingSummary,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 12),
                                    _Row(l.hotel, h.name),
                                    _Row(l.address, l.cityTunisia(h.city)),
                                    _Row(l.arrival, _fmt(widget.arrival)),
                                    _Row(l.departure, _fmt(widget.departure)),
                                    _Row(l.stayDuration, l.nightsCount(nights)),
                                    _Row(l.pricePerNight,
                                        l.amountTnd('${h.pricePerNight}.00')),
                                    _Row(l.totalPrice, l.amountTnd('$total'),
                                        big: true),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(l.choosePaymentMethod,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              LayoutBuilder(builder: (context, c) {
                                final online = _MethodCard(
                                  title: l.onlinePayment,
                                  subtitle: l.onlinePaymentDesc,
                                  icon: Icons.credit_card,
                                  color: _blue,
                                  selected: method == 'online',
                                  onTap: () =>
                                      setState(() => method = 'online'),
                                );
                                final cash = _MethodCard(
                                  title: l.cashPayment,
                                  subtitle: l.cashPaymentDesc,
                                  icon: Icons.payments,
                                  color: _green,
                                  selected: method == 'cash',
                                  onTap: () => setState(() => method = 'cash'),
                                );
                                if (c.maxWidth < 520) {
                                  return Column(children: [
                                    online,
                                    const SizedBox(height: 12),
                                    cash,
                                  ]);
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: online),
                                    const SizedBox(width: 12),
                                    Expanded(child: cash),
                                  ],
                                );
                              }),
                              if (showErrors && method == null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(l.pleaseChoosePaymentMethod,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12)),
                                ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () =>
                                    setState(() => accepted = !accepted),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: accepted,
                                      onChanged: (v) =>
                                          setState(() => accepted = v ?? false),
                                    ),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: l.iAccept,
                                          children: [
                                            TextSpan(
                                                text: l.termsAndConditions,
                                                style: const TextStyle(
                                                    color: Color(0xFF0D6EFD))),
                                            TextSpan(text: l.andThe),
                                            TextSpan(
                                                text: l.privacyPolicy,
                                                style: const TextStyle(
                                                    color: Color(0xFF0D6EFD))),
                                          ],
                                        ),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (showErrors && !accepted)
                                Padding(
                                  // start = left in LTR, right in RTL (Arabic).
                                  padding:
                                      const EdgeInsetsDirectional.only(start: 12),
                                  child: Text(l.mustAcceptTerms,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12)),
                                ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 52,
                                child: FilledButton(
                                  onPressed: loading ? null : _confirm,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          method == 'online'
                                              ? l.continueToPayment
                                              : l.confirmBooking,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: loading
                                      ? null
                                      : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: Text(l.backToDates),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// Small widgets
// =====================================================

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool big;
  const _Row(this.label, this.value, {this.big = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: big ? 17 : 14,
                  fontWeight: big ? FontWeight.w600 : FontWeight.normal)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: big ? 18 : 14,
                    fontWeight: big ? FontWeight.bold : FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.07) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? color : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStepper extends StatelessWidget {
  final int current; // 1-based
  const _PaymentStepper({required this.current});

  static const _done = Color(0xFF10B981);
  static const _active = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [l.stepCity, l.stepDates, l.stepHotel, l.stepPayment];
    final children = <Widget>[];
    for (var i = 0; i < labels.length; i++) {
      final step = i + 1;
      final done = step < current;
      final active = step == current;
      children.add(
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? _done
                    : active
                        ? _active
                        : const Color(0xFFE9ECEF),
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: _active.withOpacity(0.3),
                            blurRadius: 0,
                            spreadRadius: 4)
                      ]
                    : null,
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text('$step',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: active ? Colors.white : Colors.black45)),
            ),
            const SizedBox(height: 6),
            Text(labels[i],
                style: TextStyle(
                    fontSize: 11,
                    color: done
                        ? Colors.black54
                        : active
                            ? _active
                            : Colors.black45)),
          ],
        ),
      );
      if (i < labels.length - 1) {
        children.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 6, right: 6),
              child: Container(
                height: 2,
                color: step < current ? _done : const Color(0xFFE9ECEF),
              ),
            ),
          ),
        );
      }
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}