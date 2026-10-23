import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../l10n/l10n.dart';
import '../models/hotel.dart';

/// Hotel badge shared between the map bottom sheet and the booking screen.
/// The [Hero] makes it fly from one screen to the other.
class HotelAvatar extends StatelessWidget {
  final Hotel hotel;
  final double size;

  const HotelAvatar({super.key, required this.hotel, this.size = 56});

  static String heroTag(Hotel h) => 'hotel-avatar-${h.id}';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag(hotel),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.hotel, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}

/// Fades and slides its child in once it is first built
/// (AnimatedOpacity + AnimatedSlide). [delay] allows staggered lists.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
    this.offset = const Offset(0, 0.08),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : widget.offset,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// "Booking saved" dialog with a Lottie check-mark animation.
Future<void> showBookingSuccessDialog(
  BuildContext context, {
  required bool online,
}) {
  final l = context.l10n;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/success.json',
            width: 140,
            height: 140,
            repeat: false,
            // Never break the flow if the animation can't be loaded.
            errorBuilder: (_, _, _) => const Icon(
              Icons.check_circle,
              color: Color(0xFF10B981),
              size: 120,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.bookingConfirmedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            online ? l.bookingConfirmedOnline : l.bookingConfirmedCash,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.seeMyBookings),
        ),
      ],
    ),
  );
}
