import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../widgets/language_menu_button.dart';
import 'payment_screen.dart';

class DateSelectionScreen extends StatefulWidget {
  final Hotel hotel;

  const DateSelectionScreen({super.key, required this.hotel});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  static const _purple = Color(0xFF667EEA);
  static const _purpleDark = Color(0xFF764BA2);

  DateTime? arrival;
  DateTime? departure;

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  int get nights =>
      (arrival != null && departure != null)
          ? departure!.difference(arrival!).inDays
          : 0;

  String _fmt(DateTime? d) => d == null
      ? '--/--/----'
      : '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/${d.year}';

  // Day name in the current language (lundi / Monday / الاثنين).
  String _weekday(DateTime? d) => d == null
      ? '--'
      : DateFormat.EEEE(context.l10n.localeName).format(d);

  Future<void> _pickArrival() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: arrival ?? _today,
      firstDate: _today,
      lastDate: _today.add(const Duration(days: 365)),
      helpText: context.l10n.arrivalDate,
    );
    if (picked == null) return;
    setState(() {
      arrival = picked;
      if (departure != null && !departure!.isAfter(picked)) departure = null;
    });
  }

  Future<void> _pickDeparture() async {
    final first = (arrival ?? _today).add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: (departure != null && !departure!.isBefore(first))
          ? departure!
          : first,
      firstDate: first,
      lastDate: _today.add(const Duration(days: 400)),
      helpText: context.l10n.departureDate,
    );
    if (picked == null) return;
    setState(() => departure = picked);
  }

  void _applySuggestion(int daysFromToday) {
    final start = _today.add(Duration(days: daysFromToday));
    setState(() {
      arrival = start;
      departure = start.add(const Duration(days: 1));
    });
  }

  void _continue() {
    if (arrival == null || departure == null || nights <= 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          hotel: widget.hotel,
          arrival: arrival!,
          departure: departure!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        backgroundColor: const Color(0xFF212529),
        foregroundColor: Colors.white,
        actions: const [LanguageMenuButton()],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_purple, _purpleDark],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;
            if (wide) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: SingleChildScrollView(child: _hero())),
                    const SizedBox(width: 32),
                    SizedBox(
                      width: 520,
                      child: SingleChildScrollView(child: _card()),
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _hero(compact: true),
                  const SizedBox(height: 16),
                  _card(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------- Left panel ----------
  Widget _hero({bool compact = false}) {
    final l = context.l10n;
    final h = widget.hotel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.bookYourStayIn(h.city),
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 26 : 38,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l.chooseDatesAndBook(h.name),
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.selectedHotel,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(h.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  h.stars,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              Text(l.pricePerNightShort('${h.pricePerNight}'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  _Perk(l.perkClimate),
                  _Perk(l.perkPrices),
                  _Perk(l.perkStars),
                  _Perk(l.perkWifi),
                ],
              ),
            ],
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 28),
          Text(l.whyBookNow,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _Reason(l.reasonBestPrice, l.reasonBestPriceDesc),
          _Reason(l.reasonFreeCancel, l.reasonFreeCancelDesc),
          _Reason(l.reasonPremium, l.reasonPremiumDesc),
        ],
      ],
    );
  }

  // ---------- Right card ----------
  Widget _card() {
    final l = context.l10n;
    final h = widget.hotel;
    final canContinue = nights > 0;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.selectYourDates,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(l.selectYourDatesSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            const _BookingStepper(current: 2),
            const SizedBox(height: 20),

            // Destination
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.destination(h.city),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0B3D91))),
                        const SizedBox(height: 4),
                        Text(h.name,
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(l.selected,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date fields
            LayoutBuilder(builder: (context, c) {
              final arrivalField = _DateField(
                label: l.arrivalDate,
                value: arrival == null ? null : _fmt(arrival),
                helper: l.selectArrivalHelper,
                onTap: _pickArrival,
              );
              final departureField = _DateField(
                label: l.departureDate,
                value: departure == null ? null : _fmt(departure),
                helper: l.stayDurationHelper(
                    nights > 0 ? l.nightsCount(nights) : '--'),
                onTap: _pickDeparture,
              );
              if (c.maxWidth < 420) {
                return Column(children: [
                  arrivalField,
                  const SizedBox(height: 16),
                  departureField,
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: arrivalField),
                  const SizedBox(width: 16),
                  Expanded(child: departureField),
                ],
              );
            }),
            const SizedBox(height: 16),

            // Suggestions
            Row(
              children: [
                Text(l.suggestions,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Suggestion(l.today, () => _applySuggestion(0)),
                      _Suggestion(l.inDays(7), () => _applySuggestion(7)),
                      _Suggestion(l.inDays(14), () => _applySuggestion(14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryDate(l.arrival.toUpperCase(), _fmt(arrival),
                          _weekday(arrival)),
                      _SummaryDate(l.departure.toUpperCase(), _fmt(departure),
                          _weekday(departure)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l.nightsInCity(nights, h.city),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (canContinue) ...[
                    const SizedBox(height: 6),
                    Text(
                        l.totalWithAmount(
                            l.amountTnd('${nights * h.pricePerNight}')),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _purpleDark)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: canContinue ? _continue : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(l.continueButton,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(l.changeDestination),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// Small widgets
// =====================================================

class _Perk extends StatelessWidget {
  final String text;
  const _Perk(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(color: Colors.white, fontSize: 13));
}

class _Reason extends StatelessWidget {
  final String title;
  final String subtitle;
  const _Reason(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingStepper extends StatelessWidget {
  final int current; // 1-based
  const _BookingStepper({required this.current});

  static const _color = Color(0xFF667EEA);

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
                color: (done || active) ? _color : const Color(0xFFE9ECEF),
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text('$step',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: active ? Colors.white : Colors.black45)),
            ),
            const SizedBox(height: 4),
            Text(labels[i],
                style: TextStyle(
                    fontSize: 12,
                    color: (done || active) ? _color : Colors.black45)),
          ],
        ),
      );
      if (i < labels.length - 1) {
        children.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 4, right: 4),
              child: Container(
                height: 2,
                color: step < current ? _color : const Color(0xFFE9ECEF),
              ),
            ),
          ),
        );
      }
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String? value;
  final String helper;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.helper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5E5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(context.l10n.required,
                  style: const TextStyle(color: Colors.red, fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 10),
                Text(value ?? context.l10n.datePlaceholder,
                    style: TextStyle(
                        fontSize: 16,
                        color: value == null ? Colors.black38 : Colors.black87)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(helper,
            style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}

class _Suggestion extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _Suggestion(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: const Color(0xFF0D6EFD),
        side: const BorderSide(color: Color(0xFF0D6EFD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _SummaryDate extends StatelessWidget {
  final String label;
  final String date;
  final String weekday;
  const _SummaryDate(this.label, this.date, this.weekday);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(date,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(weekday,
            style: const TextStyle(fontSize: 12, color: Colors.black45)),
      ],
    );
  }
}