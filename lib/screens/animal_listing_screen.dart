import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';
import '../models/animal_model.dart';
import '../services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnimalListingScreen — loads animals from API
// ─────────────────────────────────────────────────────────────────────────────
class AnimalListingScreen extends StatefulWidget {
  const AnimalListingScreen({super.key});

  @override
  State<AnimalListingScreen> createState() => _AnimalListingScreenState();
}

class _AnimalListingScreenState extends State<AnimalListingScreen> {
  String _selectedFilter = 'All Animals';
  final TextEditingController _searchController = TextEditingController();

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);

  // ── State ──
  List<AnimalModel> _animals = [];
  List<String> _filterOptions = ['All Animals'];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() { _loading = true; _error = null; });
      final animals = await apiService.getAnimals();

      // Collect unique type filters
      final types = animals
          .map((a) => a.animalTypeName ?? 'Unknown')
          .toSet()
          .toList();
      types.sort();

      if (mounted) {
        setState(() {
          _animals = animals;
          _filterOptions = ['All Animals', ...types];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<AnimalModel> get _filteredAnimals {
    var list = _animals;

    // Type filter
    if (_selectedFilter != 'All Animals') {
      list = list.where((a) => (a.animalTypeName ?? '') == _selectedFilter).toList();
    }

    // Search
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((a) =>
        a.displayName.toLowerCase().contains(q) ||
        a.tagNumber.toLowerCase().contains(q) ||
        (a.breedName ?? '').toLowerCase().contains(q)
      ).toList();
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
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 22),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'Our Animals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by name, tag or breed...',
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
          const SizedBox(height: 10),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    selectedColor: _primaryGreen,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF374151),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12.5,
                    ),
                    backgroundColor: const Color(0xFFF3F4F6),
                    onSelected: (_) => setState(() => _selectedFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
            Text('Loading animals...', style: TextStyle(color: Color(0xFF6B7280))),
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
              const Text('Could not load animals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
              const SizedBox(height: 8),
              const Text('Check your connection and try again.',
                  style: TextStyle(color: Color(0xFF6B7280)), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    final items = _filteredAnimals;

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text('No animals found', style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: _primaryGreen,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) => _buildAnimalCard(items[i]),
      ),
    );
  }

  Widget _buildAnimalCard(AnimalModel animal) {
    final statusColor = _statusColor(animal.status);
    final statusLabel = _statusLabel(animal.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  color: _primaryGreen.withValues(alpha: 0.07),
                  child: Center(
                    child: CowHeadIcon(
                      size: 48,
                      color: _primaryGreen.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              // Tag badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    animal.tagNumber,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              // Status badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.displayName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  animal.breedDisplay,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.male, size: 13, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(
                      animal.gender.toUpperCase(),
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
                    ),
                    if (animal.weight != null) ...[
                      const Spacer(),
                      const Icon(Icons.monitor_weight_outlined, size: 13, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 3),
                      Text(
                        '${animal.weight!.toStringAsFixed(0)} kg',
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
                if (animal.speciesName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      animal.speciesName,
                      style: const TextStyle(fontSize: 10.5, color: _primaryGreen, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active': return const Color(0xFF22C55E);
      case 'sick': return const Color(0xFFEF4444);
      case 'dry': return const Color(0xFFF59E0B);
      case 'sold': return const Color(0xFF8B5CF6);
      case 'deceased': return const Color(0xFF374151);
      default: return const Color(0xFF6B7280);
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active': return 'Active';
      case 'sick': return 'Sick';
      case 'dry': return 'Dry';
      case 'sold': return 'Sold';
      case 'deceased': return 'Deceased';
      default: return status;
    }
  }
}
