import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../data/hotels_seed.dart';
import '../../l10n/l10n.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animations.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/language_menu_button.dart';
import '../../widgets/theme_toggle_button.dart';
import '../booking/date_selection_screen.dart';
import 'home_shell.dart';

/// "Explorer" tab: hotels on a map or as a list (TabBar).
class HotelsMapScreen extends StatefulWidget {
  const HotelsMapScreen({super.key});

  @override
  State<HotelsMapScreen> createState() => _HotelsMapScreenState();
}

class _HotelsMapScreenState extends State<HotelsMapScreen> {
  // Many tiles fail at once when offline: warn the user only once.
  bool _tileErrorShown = false;

  // Catalogue managed by the admin (Firestore). The built-in list is shown
  // until it loads, and kept if Firestore is unreachable.
  List<Hotel> _hotels = seedHotels;
  StreamSubscription<List<Hotel>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = HotelService()
        .watchAll(fallbackToSeed: true)
        .listen(
          (hotels) => setState(() => _hotels = hotels),
          onError: (Object e) => debugPrint('Hotels stream error: $e'),
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onTileError(TileImage tile, Object error, StackTrace? stackTrace) {
    if (_tileErrorShown || !mounted) return;
    _tileErrorShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.showError(context.l10n.mapLoadError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = _hotels
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

    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: HomeShell.isIn(context) ? const MenuButton() : null,
          title: Text(l.hotelsInTunisia),
          actions: const [ThemeToggleButton(), LanguageMenuButton()],
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.map), text: l.tabMap),
              Tab(icon: const Icon(Icons.list), text: l.tabList),
            ],
          ),
        ),
        body: TabBarView(
          // Horizontal drags must pan the map, not switch tabs.
          physics: const NeverScrollableScrollPhysics(),
          children: [_map(markers), _list()],
        ),
      ),
    );
  }

  Widget _map(List<Marker> markers) {
    return FlutterMap(
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
          // Darker map tiles in dark mode.
          tileBuilder: context.isDark ? darkModeTileBuilder : null,
          errorTileCallback: _onTileError,
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
    );
  }

  Widget _list() {
    final l = context.l10n;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _hotels.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 88),
      itemBuilder: (context, i) {
        final h = _hotels[i];
        return FadeSlideIn(
          delay: Duration(milliseconds: 40 * (i < 10 ? i : 10)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: HotelAvatar(hotel: h),
            title: Text(
              h.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                Flexible(child: Text(h.city, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                ...List.generate(
                  h.stars,
                  (_) => const Icon(Icons.star, color: Colors.amber, size: 14),
                ),
              ],
            ),
            trailing: Text(
              l.pricePerNightShort('${h.pricePerNight}'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // The avatar flies (Hero) to the date selection screen.
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DateSelectionScreen(hotel: h)),
            ),
          ),
        );
      },
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
            Row(
              children: [
                HotelAvatar(hotel: h, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(h.city),
                    ],
                  ),
                ),
              ],
            ),
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
                  // The sheet stays open underneath so the hotel avatar
                  // can fly (Hero) to the next screen.
                  Navigator.push(
                    sheetContext,
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
