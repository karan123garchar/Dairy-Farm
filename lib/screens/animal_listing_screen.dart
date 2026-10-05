import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';
import '../models/animal_model.dart';
import '../services/api_service.dart';
import 'animal_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnimalListingScreen — Displays static herd with seamless API sync
// ─────────────────────────────────────────────────────────────────────────────
class AnimalListingScreen extends StatefulWidget {
  const AnimalListingScreen({super.key});

  @override
  State<AnimalListingScreen> createState() => _AnimalListingScreenState();
}

class _AnimalListingScreenState extends State<AnimalListingScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _accentGreen = Color(0xFF2D6A4F);
  static const Color _bg = Color(0xFFEFF6F1);

  // ── Static animals always available ──
  static const List<Animal> _staticAnimals = [
    Animal(
      tagId: 'COW-001',
      name: 'Jersey Purebred',
      breed: 'Cow',
      age: 'Age: 4.5 Years',
      imagePath: 'assets/images/jersey_cow.png',
      status: 'Healthy',
      todayYield: '16.5 Liters',
      lastCheckup: '2 Days ago',
      location: 'Pune, Maharashtra',
    ),
    Animal(
      tagId: 'BUF-014',
      name: 'Murrah Buffalo',
      breed: 'Buffalo',
      age: 'Age: 6 Years',
      imagePath: 'assets/images/murrah_buffalo.png',
      status: 'Healthy',
      todayYield: '12.2 Liters',
      lastCheckup: '12.2 Liters',
      location: 'Haryana',
    ),
    Animal(
      tagId: 'COW-009',
      name: 'Holstein Friesian',
      breed: 'Cow',
      age: 'Age: 3 Years',
      imagePath: 'assets/images/holstein_friesian.png',
      status: 'Sick',
      todayYield: '9.0 Liters',
      lastCheckup: 'Mastitis Alert',
      location: 'Gujarat',
    ),
    Animal(
      tagId: 'COW-005',
      name: 'Jersey Purebred',
      breed: 'Cow',
      age: 'Age: 5 Years',
      imagePath: 'assets/images/jersey_cow.png',
      status: 'Healthy',
      todayYield: '21.0 Liters',
      lastCheckup: '5 Days ago',
      location: 'Pune, Maharashtra',
    ),
    Animal(
      tagId: 'GIR-003',
      name: 'Gir Cow',
      breed: 'Cow',
      age: 'Age: 6 Years',
      imagePath: 'assets/images/gir_cow.png',
      status: 'Healthy',
      todayYield: '18.4 Liters',
      lastCheckup: '1 Day ago',
      location: 'Rajkot, Gujarat',
    ),
    Animal(
      tagId: 'BUF-022',
      name: 'Murrah Buffalo',
      breed: 'Buffalo',
      age: 'Age: 4 Years',
      imagePath: 'assets/images/murrah_buffalo.png',
      status: 'Sick',
      todayYield: '8.1 Liters',
      lastCheckup: 'Fever Alert',
      location: 'Haryana',
    ),
  ];

  // ── State ──
  late List<Animal> _animals;
  List<String> _filters = ['All Animals', 'Cow', 'Buffalo', 'Jersey B'];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animals = List<Animal>.from(_staticAnimals);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isRefreshing = true);
      final apiAnimals = await apiService.getAnimals();

      if (apiAnimals.isNotEmpty && mounted) {
        final existingTagIds = _staticAnimals.map((a) => a.tagId.toLowerCase()).toSet();
        final newAnimals = apiAnimals
            .map(_fromAnimalModel)
            .where((a) => !existingTagIds.contains(a.tagId.toLowerCase()))
            .toList();

        final extraFilters = apiAnimals
            .map((a) => a.animalTypeName ?? a.breedDisplay)
            .where((t) => t.isNotEmpty && !_filters.contains(t))
            .toSet()
            .toList();
        extraFilters.sort();

        setState(() {
          _animals = [..._staticAnimals, ...newAnimals];
          _filters = ['All Animals', 'Cow', 'Buffalo', 'Jersey B', ...extraFilters];
          _isRefreshing = false;
        });
      } else {
        if (mounted) setState(() => _isRefreshing = false);
      }
    } catch (e) {
      debugPrint('API getAnimals failed or offline: $e');
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Animal _fromAnimalModel(AnimalModel m) {
    String img = 'assets/images/jersey_cow.png';
    final bName = (m.breedName ?? '').toLowerCase();
    final tName = (m.animalTypeName ?? '').toLowerCase();
    if (bName.contains('buffalo') || tName.contains('buffalo') || bName.contains('murrah')) {
      img = 'assets/images/murrah_buffalo.png';
    } else if (bName.contains('gir')) {
      img = 'assets/images/gir_cow.png';
    } else if (bName.contains('holstein') || bName.contains('friesian')) {
      img = 'assets/images/holstein_friesian.png';
    }

    final st = m.status.toLowerCase();
    String statusLabel = 'Healthy';
    if (st == 'sick') {
      statusLabel = 'Sick';
    } else if (st == 'dry' || st == 'pregnant') {
      statusLabel = 'Alert';
    }

    return Animal(
      tagId: m.tagNumber,
      name: m.displayName,
      breed: m.breedDisplay,
      age: m.dateOfBirth != null ? 'Age: ${m.dateOfBirth}' : 'Age: 3.5 Years',
      imagePath: img,
      status: statusLabel,
      todayYield: '15.0 Liters',
      lastCheckup: 'Recent',
      location: 'Krishna Dairy Farm',
    );
  }

  List<Animal> get _filteredAnimals {
    final filter = _filters.length > _selectedFilterIndex
        ? _filters[_selectedFilterIndex]
        : 'All Animals';

    var list = _animals;

    if (filter != 'All Animals') {
      if (filter == 'Jersey B') {
        list = list.where((a) => a.name.contains('Jersey') || a.breed.contains('Jersey')).toList();
      } else {
        list = list.where((a) =>
            a.breed.toLowerCase().contains(filter.toLowerCase()) ||
            a.name.toLowerCase().contains(filter.toLowerCase())).toList();
      }
    }

    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((a) =>
        a.name.toLowerCase().contains(q) ||
        a.tagId.toLowerCase().contains(q) ||
        a.breed.toLowerCase().contains(q) ||
        a.location.toLowerCase().contains(q)
      ).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const UserDrawer(),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          if (_isRefreshing)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_accentGreen),
              minHeight: 2,
            ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: 0),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
          onPressed: _loadData,
          tooltip: 'Refresh Animals',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/dairy_logo.png',
              width: 34,
              height: 34,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                radius: 16,
                backgroundColor: _accentGreen,
                child: Text(
                  'K',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 13.5),
              decoration: InputDecoration(
                hintText: 'Search by Tag ID, Name or Breed...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Color(0xFF9CA3AF)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Filter Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _buildFilterChip(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryGreen : const Color(0xFFD1D5DB),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          _filters[index],
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final items = _filteredAnimals;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 16),
              const Text(
                'No animals found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Try adjusting your search or filter options',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedFilterIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Reset Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: _primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildAnimalCard(items[index]),
      ),
    );
  }

  Widget _buildAnimalCard(Animal animal) {
    final statusColor = _statusColor(animal.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimalDetailScreen(animal: animal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // ── Animal Image with Badges ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildAnimalImage(animal.imagePath),
                ),
                // Tag ID badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      animal.tagId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      animal.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Card Body ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Menu
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          animal.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showOptions(context, animal),
                        child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        animal.age,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(' • ', style: TextStyle(color: Color(0xFF9CA3AF))),
                      Flexible(
                        child: Text(
                          animal.location,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    children: [
                      // Today's Yield
                      Expanded(
                        child: _buildStat(
                          icon: Icons.water_drop_outlined,
                          iconColor: const Color(0xFF3B82F6),
                          label: "TODAY'S YIELD",
                          value: animal.todayYield,
                          valueColor: const Color(0xFF1F2937),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: const Color(0xFFE5E7EB),
                      ),
                      // Last Checkup
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: _buildStat(
                            icon: animal.status.toLowerCase() == 'sick'
                                ? Icons.warning_amber_rounded
                                : Icons.calendar_today_outlined,
                            iconColor: animal.status.toLowerCase() == 'sick'
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF10B981),
                            label: 'LAST CHECKUP',
                            value: animal.lastCheckup,
                            valueColor: animal.status.toLowerCase() == 'sick'
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: 170,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }
    return Image.asset(
      path,
      height: 170,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackImage(),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 170,
      width: double.infinity,
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: CowHeadIcon(size: 54, color: _primaryGreen),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
      case 'active':
        return const Color(0xFF22C55E);
      case 'sick':
        return const Color(0xFFEF4444);
      case 'dry':
      case 'pregnant':
      case 'alert':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _showOptions(BuildContext context, Animal animal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility_outlined, color: _primaryGreen),
                title: const Text('View Details', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnimalDetailScreen(animal: animal),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: _primaryGreen),
                title: const Text('View Photos & Videos', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnimalDetailScreen(animal: animal),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
