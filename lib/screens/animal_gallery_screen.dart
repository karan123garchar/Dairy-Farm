import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';
import '../models/gallery_model.dart';
import '../services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnimalGalleryScreen — loads animal gallery from API
// ─────────────────────────────────────────────────────────────────────────────
class AnimalGalleryScreen extends StatefulWidget {
  final String animalName;
  final String tagId;

  const AnimalGalleryScreen({
    super.key,
    this.animalName = 'Animal Gallery',
    this.tagId = '',
  });

  @override
  State<AnimalGalleryScreen> createState() => _AnimalGalleryScreenState();
}

class _AnimalGalleryScreenState extends State<AnimalGalleryScreen> {
  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);

  List<GalleryItemModel> _items = [];
  bool _loading = true;
  String? _error;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    try {
      setState(() { _loading = true; _error = null; });
      final gallery = await apiService.getAnimalGallery();
      if (mounted) setState(() { _items = gallery; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.animalName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              '${_items.length} photos',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadGallery,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _primaryGreen),
            SizedBox(height: 16),
            Text('Loading gallery...', style: TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 16),
              const Text('Could not load gallery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
              const SizedBox(height: 8),
              const Text('Check your connection and try again.',
                  style: TextStyle(color: Color(0xFF6B7280)), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadGallery,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library_outlined, size: 80, color: Color(0xFFD1FAE5)),
            const SizedBox(height: 16),
            const Text('No photos yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
            const SizedBox(height: 8),
            const Text('Gallery images will appear here once uploaded from the admin panel.',
                style: TextStyle(color: Color(0xFF6B7280)), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadGallery,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGallery,
      color: _primaryGreen,
      child: CustomScrollView(
        slivers: [
          // Stats header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0C3823), Color(0xFF166534)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.photo_library, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_items.length} Photos',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const Text('Animal Gallery', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildGalleryCard(_items[index], index),
                childCount: _items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(GalleryItemModel item, int index) {
    final isSelected = _selectedIndex == index;
    final imageUrl = item.imageUrl ?? item.imagePath;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = isSelected ? null : index);
        _showFullImage(item);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _primaryGreen : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.15 : 0.06),
              blurRadius: isSelected ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image from URL
                    _buildNetworkImage(imageUrl),
                    // Gradient overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                          ),
                        ),
                      ),
                    ),
                    if (item.animalTag != null)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.animalTag!,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Caption
              if (item.caption != null && item.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Text(
                    item.caption!,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF374151), fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Text(
                    item.animalName ?? 'Animal Photo #${item.id}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF374151), fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: _primaryGreen.withValues(alpha: 0.06),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _primaryGreen)),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          color: _primaryGreen.withValues(alpha: 0.06),
          child: const Center(child: CowHeadIcon(size: 50, color: Color(0x440C3823))),
        ),
      );
    }
    return Container(
      color: _primaryGreen.withValues(alpha: 0.06),
      child: const Center(child: CowHeadIcon(size: 50, color: Color(0x440C3823))),
    );
  }

  void _showFullImage(GalleryItemModel item) {
    final imageUrl = item.imageUrl ?? item.imagePath;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildNetworkImage(imageUrl),
            ),
            if (item.caption != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  item.caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
