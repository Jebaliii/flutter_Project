import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../data/hotels_seed.dart';
import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../widgets/language_menu_button.dart';
import '../booking/date_selection_screen.dart';

class HotelsMapScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const HotelsMapScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final markers = seedHotels
        .map(
          (h) => Marker(
            point: LatLng(h.lat, h.lng),
            width: 44,
            height: 44,
            child: GestureDetector(
              onTap: () => _showHotel(context, h),
              child: const Icon(Icons.location_on, color: Colors.red, size: 44),
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.hotelsInTunisia),
        actions: [
          const LanguageMenuButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.logout,
            onPressed: onLogout,
          ),
        ],
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(34.2, 9.6),
          initialZoom: 6.2,
          minZoom: 5,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.project_0',
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 60,
              size: const Size(44, 44),
              markers: markers,
              builder: (context, clusterMarkers) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade700,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${clusterMarkers.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  void _showHotel(BuildContext context, Hotel h) {
    final l = context.l10n;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(h.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(h.city),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(
                  h.stars,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                const Spacer(),
                Text(
                  l.pricePerNightShort('${h.pricePerNight}'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                icon: const Icon(Icons.event_available),
                label: Text(l.bookThisHotel),
                onPressed: () {
                  Navigator.pop(sheetContext); // ferme le bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DateSelectionScreen(hotel: h),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}