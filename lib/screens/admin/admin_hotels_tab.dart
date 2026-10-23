import 'package:flutter/material.dart';

import '../../data/hotels_seed.dart';
import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_feedback.dart';
import 'admin_common.dart';
import 'hotel_form_screen.dart';

/// Hotels catalogue: add (FAB of the shell), edit, delete.
class AdminHotelsTab extends StatefulWidget {
  const AdminHotelsTab({super.key});

  @override
  State<AdminHotelsTab> createState() => _AdminHotelsTabState();
}

class _AdminHotelsTabState extends State<AdminHotelsTab> {
  final _service = HotelService();
  late Stream<List<Hotel>> _hotels = _service.watchAll();
  String _query = '';
  bool _importing = false;

  void _retry() => setState(() => _hotels = _service.watchAll());

  Future<void> _import() async {
    setState(() => _importing = true);
    await runAdminAction(
      context,
      _service.importSeed,
      context.l10n.hotelsImported(seedHotels.length),
    );
    if (mounted) setState(() => _importing = false);
  }

  Future<void> _delete(Hotel h) async {
    final l = context.l10n;
    if (!await confirmDelete(context, h.name)) return;
    if (!mounted) return;
    await runAdminAction(context, () => _service.delete(h.id), l.hotelDeleted);
  }

  void _edit(Hotel h) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => HotelFormScreen(hotel: h)),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return StreamBuilder<List<Hotel>>(
      stream: _hotels,
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
        // Nothing in Firestore yet: clients see the built-in catalogue,
        // offer to import it so it can be managed here.
        if (all.isEmpty) {
          return Center(
            child: StateMessage(
              icon: Icons.hotel,
              title: l.noHotels,
              message: l.noHotelsDesc(seedHotels.length),
              actionLabel: _importing ? null : l.importHotels,
              actionIcon: Icons.download,
              onAction: _import,
            ),
          );
        }

        final q = _query.trim().toLowerCase();
        final filtered = all
            .where(
              (h) =>
                  q.isEmpty ||
                  h.name.toLowerCase().contains(q) ||
                  h.city.toLowerCase().contains(q),
            )
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: AdminSearchField(
                hint: l.searchHint,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: StateMessage(
                        icon: Icons.search_off,
                        title: l.noHotels,
                      ),
                    )
                  : ListView.builder(
                      // Room for the "Add" FAB.
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => _tile(filtered[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(Hotel h) {
    final l = context.l10n;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => _edit(h),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF667EEA),
          foregroundColor: Colors.white,
          child: Icon(Icons.hotel),
        ),
        title: Text(
          h.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Flexible(child: Text(h.city, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 6),
            const Icon(Icons.star, color: Colors.amber, size: 14),
            Text('${h.stars}'),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l.pricePerNightShort('${h.pricePerNight}'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (a) => a == 'edit' ? _edit(h) : _delete(h),
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: menuRow(Icons.edit, l.edit)),
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
      ),
    );
  }
}
