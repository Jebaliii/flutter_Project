import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';
import '../../widgets/app_feedback.dart';

/// Create ([hotel] null) or edit a hotel.
class HotelFormScreen extends StatefulWidget {
  final Hotel? hotel;

  const HotelFormScreen({super.key, this.hotel});

  @override
  State<HotelFormScreen> createState() => _HotelFormScreenState();
}

class _HotelFormScreenState extends State<HotelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.hotel?.name);
  late final _city = TextEditingController(text: widget.hotel?.city);
  late final _lat = TextEditingController(text: widget.hotel?.lat.toString());
  late final _lng = TextEditingController(text: widget.hotel?.lng.toString());
  late final _price = TextEditingController(
    text: widget.hotel?.pricePerNight.toString(),
  );
  late int _stars = widget.hotel?.stars ?? 4;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _city, _lat, _lng, _price]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l = context.l10n;
    setState(() => _saving = true);
    try {
      await HotelService().save(
        Hotel(
          id: widget.hotel?.id ?? '',
          name: _name.text.trim(),
          city: _city.text.trim(),
          lat: double.parse(_lat.text.trim()),
          lng: double.parse(_lng.text.trim()),
          stars: _stars,
          pricePerNight: int.parse(_price.text.trim()),
        ),
      );
      if (!mounted) return;
      context.showSuccess(l.hotelSaved);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      context.showError(e);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? context.l10n.required : null;

  /// Number between [min] and [max].
  String? Function(String?) _number(double min, double max) => (v) {
    final n = double.tryParse(v?.trim() ?? '');
    if (n == null || n < min || n > max) return context.l10n.invalidNumber;
    return null;
  };

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const gap = SizedBox(height: 14);
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]'))];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel == null ? l.addHotel : l.editHotel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: _dec(l.hotelName, Icons.hotel),
                    validator: _required,
                  ),
                  gap,
                  TextFormField(
                    controller: _city,
                    decoration: _dec(l.stepCity, Icons.location_city),
                    validator: _required,
                  ),
                  gap,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lat,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          inputFormatters: decimal,
                          decoration: _dec(l.latitude, Icons.place),
                          validator: _number(-90, 90),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lng,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          inputFormatters: decimal,
                          decoration: _dec(l.longitude, Icons.place),
                          validator: _number(-180, 180),
                        ),
                      ),
                    ],
                  ),
                  gap,
                  TextFormField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _dec(l.pricePerNightTnd, Icons.payments),
                    validator: _number(1, 100000),
                  ),
                  gap,
                  Text(l.stars),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          tooltip: '$i',
                          onPressed: () => setState(() => _stars = i),
                          icon: Icon(
                            i <= _stars ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const ButtonSpinner()
                          : const Icon(Icons.save),
                      label: Text(l.save),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
