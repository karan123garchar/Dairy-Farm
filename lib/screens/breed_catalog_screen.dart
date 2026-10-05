import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';
import '../models/breed_model.dart';
import '../services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Breed Catalog Screen — loads breeds from API
// ─────────────────────────────────────────────────────────────────────────────
class BreedCatalogScreen extends StatefulWidget {
  const BreedCatalogScreen({super.key});

  @override
  State<BreedCatalogScreen> createState() => _BreedCatalogScreenState();
}

class _BreedCatalogScreenState extends State<BreedCatalogScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);

  final List<String> _filters = ['All Breeds', 'Cattle Breeds', 'Buffalo Breeds'];

  static final List<Breed> _defaultBreeds = [
    Breed(
      id: 1,
      animalTypeId: 1,
      name: 'Gir Cow',
      description:
          'The Gir is one of the principal Zebu breeds originating in India. Known for its high tolerance to tropical heat and resistance to diseases, it produces A2 nutrient-rich milk.',
      animalTypeName: 'Cow',
    ),
    Breed(
      id: 2,
      animalTypeId: 1,
      name: 'Holstein Friesian',
      description:
          'Holstein Friesian cattle are the highest-production dairy animals in the world. Recognizable by distinctive black-and-white markings, ideal for high yield operations.',
      animalTypeName: 'Cow',
    ),
    Breed(
      id: 3,
      animalTypeId: 1,
      name: 'Jersey Purebred',
      description:
          'Jerseys are famous for high butterfat content in milk and lower maintenance costs due to smaller body mass and superior feed conversion efficiency.',
      animalTypeName: 'Cow',
    ),
    Breed(
      id: 4,
      animalTypeId: 2,
      name: 'Murrah Buffalo',
      description:
          'Murrah is the premier water buffalo breed of India, originating from Haryana and Punjab. Known for jet-black coats and high butterfat milk.',
      animalTypeName: 'Buffalo',
    ),
  ];

  // ── State ──
  late List<Breed> _breeds;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _breeds = List<Breed>.from(_defaultBreeds);
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    try {
      final breeds = await apiService.getBreeds();
      if (mounted && breeds.isNotEmpty) {
        final existingNames = _defaultBreeds.map((b) => b.name.toLowerCase()).toSet();
        final newBreeds = breeds.where((b) => !existingNames.contains(b.name.toLowerCase())).toList();
        setState(() {
          _breeds = [..._defaultBreeds, ...newBreeds];
        });
      }
    } catch (_) {
      // Keep static breeds gracefully
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Breed> get _filteredBreeds {
    var list = _breeds;

    // Filter by category keyword
    if (_selectedFilterIndex == 1) {
      // Cattle: exclude buffalo types
      list = list.where((b) {
        final t = (b.animalTypeName ?? b.name).toLowerCase();
        return !t.contains('buffalo');
      }).toList();
    } else if (_selectedFilterIndex == 2) {
      list = list.where((b) {
        final t = (b.animalTypeName ?? b.name).toLowerCase();
        return t.contains('buffalo');
      }).toList();
    }

    // Search
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((b) => b.name.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        elevation: 0,
        title: const Text(
          'Breed Catalog',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadBreeds,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'REFERENCE CATALOG',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: _primaryGreen,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Dairy Cattle & Buffalo Breeds',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _primaryGreen,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Explore genetics, average annual yield, fat percentages, and climate adaptability.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search breed name...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (index) {
            final isSelected = _selectedFilterIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_filters[index]),
                selected: isSelected,
                selectedColor: _primaryGreen,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: const Color(0xFFF3F4F6),
                onSelected: (_) => setState(() => _selectedFilterIndex = index),
              ),
            );
          }),
        ),
      ),
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
            Text('Loading breeds...', style: TextStyle(color: Color(0xFF6B7280))),
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
              const Text(
                'Could not load breeds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
              ),
              const SizedBox(height: 8),
              Text(
                'Check your connection and try again.',
                style: const TextStyle(color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadBreeds,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    final items = _filteredBreeds;

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text('No breeds found', style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBreeds,
      color: _primaryGreen,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => _buildBreedCard(items[i]),
      ),
    );
  }

  Widget _buildBreedCard(Breed breed) {
    final badge = breed.animalTypeName ?? 'Dairy Breed';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image / Placeholder ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: _primaryGreen.withValues(alpha: 0.08),
                  child: const Center(
                    child: CowHeadIcon(size: 70, color: Color(0x440C3823)),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _primaryGreen.withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (!(breed.status))
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Inactive', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),

          // ── Card Body ──
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  breed.name,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                if (breed.description != null && breed.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    breed.description!,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),

                // Animal type info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 16, color: _primaryGreen),
                      const SizedBox(width: 8),
                      Text(
                        'Animal Type: ${breed.animalTypeName ?? "—"}',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: breed.status ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          breed.status ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: breed.status ? const Color(0xFF166534) : const Color(0xFF991B1B),
                          ),
                        ),
                      ),
                    ],
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
