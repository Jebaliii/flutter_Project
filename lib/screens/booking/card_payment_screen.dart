import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../widgets/language_menu_button.dart';

class CardPaymentScreen extends StatefulWidget {
  final Hotel hotel;
  final DateTime arrival;
  final DateTime departure;
  final int amount;

  const CardPaymentScreen({
    super.key,
    required this.hotel,
    required this.arrival,
    required this.departure,
    required this.amount,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  static const _green = Color(0xFF10B981);
  static const _greenDark = Color(0xFF059669);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  int? _month;
  int? _year;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  int get nights => widget.departure.difference(widget.arrival).inDays;

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  String get _digits => _numberCtrl.text.replaceAll(RegExp(r'\D'), '');

  String get _brand {
    final d = _digits;
    if (d.startsWith('4')) return 'VISA';
    if (d.startsWith('34') || d.startsWith('37')) return 'AMEX';
    if (d.startsWith('5') || d.startsWith('2')) return 'MASTERCARD';
    return '';
  }

  bool _luhn(String number) {
    var sum = 0;
    var alt = false;
    for (var i = number.length - 1; i >= 0; i--) {
      var n = int.parse(number[i]);
      if (alt) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alt = !alt;
    }
    return sum % 10 == 0;
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    // SIMULATION: no card data is stored or sent anywhere.
    // TODO bonus: replace by Stripe (test mode) or Konnect sandbox.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = widget.hotel;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        title: Text(l.appName),
        backgroundColor: const Color(0xFF212529),
        foregroundColor: Colors.white,
        actions: const [LanguageMenuButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hotel chip
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(h.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Secure banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_green, _greenDark]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.securePayment,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(l.securePaymentDesc,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recap
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.bookingSummary,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            _Row(l.hotel, h.name),
                            _Row(l.address, l.cityTunisia(h.city)),
                            _Row(l.arrival, _fmt(widget.arrival)),
                            _Row(l.departure, _fmt(widget.departure)),
                            _Row(l.stayDuration, l.nightsCount(nights)),
                            _Row(l.pricePerNight,
                                l.amountTnd('${h.pricePerNight}.00')),
                            _Row(l.totalAmount, l.amountTnd('${widget.amount}'),
                                bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Brand chips
                      Row(
                        children: [
                          _BrandChip('VISA', _brand == 'VISA'),
                          const SizedBox(width: 8),
                          _BrandChip('MASTERCARD', _brand == 'MASTERCARD'),
                          const SizedBox(width: 8),
                          _BrandChip('AMEX', _brand == 'AMEX'),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Live card preview
                      _CardPreview(
                        number: _digits,
                        name: _nameCtrl.text,
                        month: _month,
                        year: _year,
                        brand: _brand,
                      ),
                      const SizedBox(height: 20),

                      // Holder
                      _Label(l.cardHolder),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _dec(l.cardHolderHint),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return l.cardHolderRequired;
                          if (t.length < 3) return l.nameTooShort;
                          // Latin (with accents) or Arabic letters.
                          if (!RegExp(r"^[A-Za-zÀ-ÿ\u0600-\u06FF' -]+$")
                              .hasMatch(t)) {
                            return l.lettersOnly;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Number + CVV
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.cardNumber),
                                TextFormField(
                                  controller: _numberCtrl,
                                  keyboardType: TextInputType.number,
                                  // Card numbers stay left-to-right in Arabic.
                                  textDirection: TextDirection.ltr,
                                  inputFormatters: [_CardNumberFormatter()],
                                  decoration: _dec('1234 5678 9012 3456'),
                                  onChanged: (_) => setState(() {}),
                                  validator: (v) {
                                    final d = (v ?? '').replaceAll(' ', '');
                                    if (d.isEmpty) return l.cardNumberRequired;
                                    final expected = _brand == 'AMEX' ? 15 : 16;
                                    if (d.length != expected) {
                                      return l.cardNumberLength(expected);
                                    }
                                    //if (!_luhn(d)) return 'Numéro de carte invalide';
                                   // return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.cvvCode),
                                TextFormField(
                                  controller: _cvvCtrl,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  decoration: _dec('123'),
                                  validator: (v) {
                                    final t = v ?? '';
                                    if (t.isEmpty) return l.cvvRequired;
                                    final expected = _brand == 'AMEX' ? 4 : 3;
                                    if (t.length != expected) {
                                      return l.digitsCount(expected);
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Month + Year
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.expiryMonth),
                                DropdownButtonFormField<int>(
                                  initialValue: _month,
                                  decoration: _dec(l.monthHint),
                                  items: List.generate(
                                    12,
                                    (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text((i + 1).toString().padLeft(2, '0')),
                                    ),
                                  ),
                                  onChanged: (v) => setState(() => _month = v),
                                  validator: (v) => v == null ? l.chooseMonth : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.expiryYear),
                                DropdownButtonFormField<int>(
                                  initialValue: _year,
                                  decoration: _dec(l.yearHint),
                                  items: List.generate(
                                    13,
                                    (i) => DropdownMenuItem(
                                      value: now.year + i,
                                      child: Text('${now.year + i}'),
                                    ),
                                  ),
                                  onChanged: (v) => setState(() => _year = v),
                                  validator: (v) {
                                    if (v == null) return l.chooseYear;
                                    if (_month != null &&
                                        v == now.year &&
                                        _month! < now.month) {
                                      return l.cardExpired;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pay
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _loading ? null : _pay,
                          style: FilledButton.styleFrom(
                            backgroundColor: _green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text(l.payAmount(l.amountTnd('${widget.amount}.00')),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed:
                              _loading ? null : () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(l.cancelPayment),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(l.sslSecured,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black54)),
                          Text(l.encryptedData,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black54)),
                          Text(l.support247,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      );
}

// =====================================================
// Helpers
// =====================================================

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 16) digits = digits.substring(0, 16);
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final s = buf.toString();
    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final String number;
  final String name;
  final int? month;
  final int? year;
  final String brand;

  const _CardPreview({
    required this.number,
    required this.name,
    required this.month,
    required this.year,
    required this.brand,
  });

  String get _numberDisplay {
    final padded = number.padRight(16, '•');
    return [
      padded.substring(0, 4),
      padded.substring(4, 8),
      padded.substring(8, 12),
      padded.substring(12, 16),
    ].join('  ');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final exp = (month == null || year == null)
        ? l.expiryPlaceholder
        : '${month.toString().padLeft(2, '0')}/${(year! % 100).toString().padLeft(2, '0')}';

    return Container(
      height: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF8B6FF0)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD93B),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Text(brand,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ],
          ),
          const Spacer(),
          Text(_numberDisplay,
              // Keep the 4 digit groups in order in Arabic (RTL).
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.cardHolder.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(
                      name.trim().isEmpty
                          ? l.namePlaceholder
                          : name.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(l.expiryDate.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 9)),
                  const SizedBox(height: 2),
                  Text(exp,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String text;
  final bool active;
  const _BrandChip(this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F0FE) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: active ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
            width: active ? 2 : 1),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF1D4ED8) : Colors.black54)),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: bold ? 15 : 13,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}