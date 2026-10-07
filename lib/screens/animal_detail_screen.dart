import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';

class Animal {
  final String name;
  final String tagId;
  final String breed;
  final String age;
  final String imagePath;
  final String status;
  final String todayYield;
  final String location;

  const Animal({
    this.name = 'Bella - Holstein Elite',
    this.tagId = 'BE-0842',
    this.breed = 'Holstein',
    this.age = '4.2 Yrs',
    this.imagePath = 'assets/images/holstein_friesian.png',
    this.status = 'Pregnant',
    this.todayYield = '34.2 Liters',
    this.location = 'Stable Block A | Pen 04',
  });
}

class AnimalDetailScreen extends StatefulWidget {
  final Animal? animal;

  const AnimalDetailScreen({
    super.key,
    this.animal,
  });

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  int _selectedTab = 0;


  final List<String> _tabs = [
    'Overview',
    'Gallery',
    'Milk Production',
    'Health Record',
  ];

  // Specific gallery images and videos simulation for this animal
  final List<GalleryMediaItem> _galleryItems = const [
    GalleryMediaItem(
      id: 'dg1',
      title: 'Full Front Profile',
      tag: 'Front View',
      imagePath: 'assets/images/holstein_friesian.png',
      isVideo: false,
      category: 'Anatomical',
    ),
    GalleryMediaItem(
      id: 'dg2',
      title: 'Left Side Standing View',
      tag: 'Left Profile',
      imagePath: 'assets/images/jersey_cow.png',
      isVideo: false,
      category: 'Anatomical',
    ),
    GalleryMediaItem(
      id: 'dg3',
      title: 'Morning Milking Routine',
      tag: 'Milking Video',
      imagePath: 'assets/images/gir_cow.png',
      isVideo: true,
      duration: '0:45',
      category: 'Routine',
    ),
    GalleryMediaItem(
      id: 'dg4',
      title: 'Right Side Udder & Stature',
      tag: 'Right Profile',
      imagePath: 'assets/images/murrah_buffalo.png',
      isVideo: false,
      category: 'Anatomical',
    ),
    GalleryMediaItem(
      id: 'dg5',
      title: 'Veterinary Health Inspection',
      tag: 'Vet Examination',
      imagePath: 'assets/images/jersey_cow.png',
      isVideo: true,
      duration: '1:20',
      category: 'Health',
    ),
    GalleryMediaItem(
      id: 'dg6',
      title: 'Nutrition & Feed Intake',
      tag: 'Feeding Time',
      imagePath: 'assets/images/gir_cow.png',
      isVideo: true,
      duration: '0:30',
      category: 'Routine',
    ),
    GalleryMediaItem(
      id: 'dg7',
      title: 'Grazing in Pasture',
      tag: 'Pasture View',
      imagePath: 'assets/images/farm_hero_banner.png',
      isVideo: false,
      category: 'Routine',
    ),
    GalleryMediaItem(
      id: 'dg8',
      title: 'Herd Gathering',
      tag: 'Group View',
      imagePath: 'assets/images/farm_animals.png',
      isVideo: false,
      category: 'Routine',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Dynamic values from animal parameter or exact mockup defaults
    final animalName = widget.animal?.name ?? 'Bella - Holstein Elite';
    final tagId = widget.animal?.tagId ?? 'BE-0842';
    final breed = widget.animal?.breed ?? 'Holstein';
    final age = widget.animal?.age.replaceAll('Age: ', '') ?? '4.2 Yrs';
    final imagePath = widget.animal?.imagePath ?? 'assets/images/holstein_friesian.png';
    final status = widget.animal?.status ?? 'Pregnant';
    final yieldValue = widget.animal?.todayYield.replaceAll(' Liters', '') ?? '34.2';
    final location = widget.animal?.location ?? 'Stable Block A | Pen 04';

    return Scaffold(
      drawer: const UserDrawer(),
      backgroundColor: const Color(0xFFEFF6F1),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image Header ──
            _buildHeroHeader(
              name: animalName.contains('-') ? animalName : '$animalName - Holstein Elite',
              tagId: tagId.startsWith('Tag') ? tagId : 'Tag #$tagId',
              imagePath: imagePath,
              location: location,
            ),

            // ── Tabs Navigation Bar ──
            _buildTabBar(),

            // ── Tab Content ──
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTabContent(
                age: age,
                breed: breed,
                status: status,
                yieldValue: yieldValue,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: -1),
    );
  }

  // ── AppBar ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C3823),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 22),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Animal Details',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 26),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ── Hero Header ──────────────────────────────────────────
  Widget _buildHeroHeader({
    required String name,
    required String tagId,
    required String imagePath,
    required String location,
  }) {
    return Stack(
      children: [
        // Image
        Container(
          height: 240,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.75),
              ],
              stops: const [0.3, 1.0],
            ),
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/holstein_friesian.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF2D6A4F),
                child: const Center(
                  child: CowHeadIcon(size: 60, color: Colors.white54),
                ),
              ),
            ),
          ),
        ),

        // Text & Badges Overlay
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Row
              Row(
                children: [
                  // Elite Producer Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C3823).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Elite Producer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tag ID Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC07A5E).withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tagId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Animal Name
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),

              // Location / Stable info
              Text(
                location,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tab Bar Navigation ────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedTab = index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? const Color(0xFF2D6A4F) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF0C3823) : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Specs 2x2 Grid ────────────────────────────────────────
  Widget _buildSpecsGrid({
    required String age,
    required String weight,
    required String breed,
    required String status,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.calendar_today_outlined,
                label: 'AGE',
                value: age,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.scale_outlined,
                label: 'WEIGHT',
                value: weight,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12, height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.groups_outlined,
                label: 'BREED',
                value: breed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.person_outline,
                label: 'STATUS',
                value: status,
                valueColor: const Color(0xFF0C3823),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = const Color(0xFF1F2937),
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0C3823)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Daily Average Yield Banner ────────────────────────────
  Widget _buildYieldBanner({required String yieldValue}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF072718),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAILY AVERAGE YIELD',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFFA3AED0),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                yieldValue,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Liters',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Health Summary Card ───────────────────────────────────
  Widget _buildHealthSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last Vet Visit',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                'Oct 12, 2023',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.88,
              minHeight: 7,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C3823)),
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
              children: [
                TextSpan(text: 'General Health Score: '),
                TextSpan(
                  text: '88/100',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Genetic Markers Card ──────────────────────────────────
  Widget _buildGeneticMarkersCard() {
    final markers = ['A2A2 Protein', 'High Longevity', 'Fertility+'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genetic Markers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: markers.map((marker) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  marker,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Recent Activity Card ──────────────────────────────────
  Widget _buildRecentActivityCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'View Full History',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0C3823),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF0C3823),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Item 1: Routine Vaccination
          _buildActivityItem(
            icon: Icons.vaccines,
            iconBg: const Color(0xFFD1FAE5),
            iconColor: const Color(0xFF059669),
            title: 'Routine Vaccination',
            subtitle: 'BVD & IBR Booster administered by Dr.Malhotra',
            timeAgo: '2 days ago',
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Item 2: Pregnancy Check
          _buildActivityItem(
            icon: Icons.medical_services_outlined,
            iconBg: const Color(0xFFFFEDD5),
            iconColor: const Color(0xFFEA580C),
            title: 'Pregnancy Check',
            subtitle: 'Confirmed 4 months via ultrasound',
            timeAgo: '15 days ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String timeAgo,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconBg,
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeAgo,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Content Switcher ──────────────────────────────────
  Widget _buildTabContent({
    required String age,
    required String breed,
    required String status,
    required String yieldValue,
  }) {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab(
          age: age,
          breed: breed,
          status: status,
          yieldValue: yieldValue,
        );
      case 1:
        return _buildGalleryTab();
      case 2:
        return _buildMilkTab(yieldValue: yieldValue);
      case 3:
        return _buildHealthTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Overview Tab ──────────────────────────────────────────
  Widget _buildOverviewTab({
    required String age,
    required String breed,
    required String status,
    required String yieldValue,
  }) {
    return Column(
      children: [
        _buildSpecsGrid(
          age: age,
          weight: '685 Kg',
          breed: breed,
          status: status,
        ),
        const SizedBox(height: 14),
        _buildYieldBanner(yieldValue: yieldValue),
        const SizedBox(height: 14),
        _buildHealthSummaryCard(),
        const SizedBox(height: 14),
        _buildGeneticMarkersCard(),
        const SizedBox(height: 14),
        _buildRecentActivityCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Gallery Tab (Inline) ──────────────────────────────────
  Widget _buildGalleryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGalleryGrid(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGalleryGrid() {
    final items = _galleryItems;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMediaCard(items[index]),
    );
  }

  Widget _buildMediaCard(GalleryMediaItem item) {
    return GestureDetector(
      onTap: () => _showMediaViewer(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.image, size: 36, color: Colors.black26),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (item.isVideo) ...[
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.videocam, color: Colors.white, size: 9),
                        const SizedBox(width: 2),
                        Text(
                          item.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
              Positioned(
                left: 8,
                right: 8,
                bottom: 6,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(color: Colors.black45, blurRadius: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMediaViewer(BuildContext context, GalleryMediaItem item) {
    bool isPlaying = false;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            return Dialog.fullscreen(
              backgroundColor: Colors.black,
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            minScale: 0.8,
                            maxScale: 3.0,
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF111827),
                                child: const Center(
                                  child: Icon(Icons.pets, size: 80, color: Colors.white30),
                                ),
                              ),
                            ),
                          ),
                          if (item.isVideo)
                            GestureDetector(
                              onTap: () {
                                setModalState(() => isPlaying = !isPlaying);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0C3823),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  item.tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.isVideo)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                children: [
                                  Slider(
                                    value: isPlaying ? 0.45 : 0.0,
                                    onChanged: (val) {},
                                    activeColor: const Color(0xFF22C55E),
                                    inactiveColor: Colors.white30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isPlaying ? '0:20' : '0:00',
                                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                                      ),
                                      Text(
                                        item.duration,
                                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined, color: Colors.white, size: 22),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.download_outlined, color: Colors.white, size: 22),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.white, size: 22),
                                onPressed: () {},
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
          },
        );
      },
    );
  }

  // ── Milk Production Tab ───────────────────────────────────
  Widget _buildMilkTab({required String yieldValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWeeklyChart(yieldValue),
        const SizedBox(height: 14),
        _buildMilkStatsGrid(),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Milking History',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 10),
              _buildMilkRecordItem('Today', '$yieldValue Liters', 'AM: 17.0 L • PM: ${double.tryParse(yieldValue) != null ? (double.parse(yieldValue) - 17.0).toStringAsFixed(1) : "17.2"} L'),
              const Divider(color: Color(0xFFF3F4F6), height: 16),
              _buildMilkRecordItem('Yesterday', '33.8 Liters', 'AM: 16.8 L • PM: 17.0 L'),
              const Divider(color: Color(0xFFF3F4F6), height: 16),
              _buildMilkRecordItem('2 days ago', '32.4 Liters', 'AM: 16.0 L • PM: 16.4 L'),
              const Divider(color: Color(0xFFF3F4F6), height: 16),
              _buildMilkRecordItem('3 days ago', '34.0 Liters', 'AM: 17.0 L • PM: 17.0 L'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWeeklyChart(String yieldValue) {
    final double todayVal = double.tryParse(yieldValue) ?? 34.2;
    final data = [32.4, todayVal, 31.8, 33.0, 35.1, 32.9, 34.0];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Production Trend (L)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(data.length, (index) {
              final yieldVal = data[index];
              final isToday = index == 1; // Tue
              final height = (yieldVal / 40.0) * 110.0;

              return Column(
                children: [
                  Text(
                    yieldVal.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? const Color(0xFF0C3823) : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 20,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isToday
                            ? [const Color(0xFF2D6A4F), const Color(0xFF0C3823)]
                            : [const Color(0xFFD1FAE5), const Color(0xFF6EE7B7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isToday ? const Color(0xFF0C3823) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMilkStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.opacity,
                label: 'AVG FAT CONTENT',
                value: '3.95 %',
                valueColor: const Color(0xFF0C3823),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.bubble_chart_outlined,
                label: 'AVG PROTEIN',
                value: '3.24 %',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.calendar_today,
                label: 'DAYS IN MILK (DIM)',
                value: '142 Days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.functions,
                label: 'TOTAL LACTATION',
                value: '4,820 L',
                valueColor: const Color(0xFF0C3823),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMilkRecordItem(String day, String total, String sessions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sessions,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        Text(
          total,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C3823),
          ),
        ),
      ],
    );
  }

  // ── Health Record Tab ─────────────────────────────────────
  Widget _buildHealthTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVitalsGrid(),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vaccination Status',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),
              _buildVaccineItem('Brucellosis Vaccine', 'Oct 10, 2023', true),
              const Divider(color: Color(0xFFF3F4F6), height: 16),
              _buildVaccineItem('Anthrax Vaccine', 'Sep 15, 2023', true),
              const Divider(color: Color(0xFFF3F4F6), height: 16),
              _buildVaccineItem('Foot and Mouth Disease (FMD)', 'Nov 20, 2023', false),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Veterinary Consultation Log',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),
              _buildVetLogItem(
                date: 'Oct 12, 2023',
                title: 'Routine Health Checkup',
                notes: 'Normal heart rate and respiration. Rumen contractions are strong and regular. Checked eyes and muzzle, all clean. Body condition score is stable at 3.75.',
                vet: 'Dr. Amit Verma',
              ),
              const Divider(color: Color(0xFFF3F4F6), height: 20),
              _buildVetLogItem(
                date: 'Sep 04, 2023',
                title: 'Post-Calving Recovery Review',
                notes: 'Excellent postpartum recovery. Normal feed intake. No signs of calcium deficiency or ketosis.',
                vet: 'Dr. Amit Verma',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVitalsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.thermostat, color: Color(0xFFD97706), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TEMP', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        SizedBox(height: 2),
                        Text('101.5 °F', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, color: Color(0xFFDC2626), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HEART RATE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        SizedBox(height: 2),
                        Text('64 bpm', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E7FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.air_outlined, color: Color(0xFF4F46E5), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RESPIRATION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        SizedBox(height: 2),
                        Text('22 / min', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.health_and_safety_outlined, color: Color(0xFF059669), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HEALTH SCORE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        SizedBox(height: 2),
                        Text('88 / 100', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVaccineItem(String title, String date, bool isDone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Target Date: $date',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFFD1FAE5) : const Color(0xFFFFEDD5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.schedule,
                size: 11,
                color: isDone ? const Color(0xFF059669) : const Color(0xFFEA580C),
              ),
              const SizedBox(width: 3),
              Text(
                isDone ? 'Administered' : 'Upcoming',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFF059669) : const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVetLogItem({
    required String date,
    required String title,
    required String notes,
    required String vet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notes,
          style: const TextStyle(
            fontSize: 11.5,
            color: Color(0xFF4B5563),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.person_pin_outlined, size: 12, color: Color(0xFF6B7280)),
            const SizedBox(width: 4),
            Text(
              vet,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────
}

class GalleryMediaItem {
  final String id;
  final String title;
  final String tag;
  final String imagePath;
  final bool isVideo;
  final String duration;
  final String category;

  const GalleryMediaItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.imagePath,
    this.isVideo = false,
    this.duration = '',
    required this.category,
  });
}