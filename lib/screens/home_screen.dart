import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/models/candidate.dart';
import 'package:my_first_app/routes/app_routes.dart';
import 'package:my_first_app/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Candidate> _allCandidates = Candidate.initialCandidates();
  List<Candidate> _filteredCandidates = [];

  final TextEditingController _searchController = TextEditingController();

  // Filtro: null = todos, true = disponíveis, false = indisponíveis
  bool? _availabilityFilter;
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _filteredCandidates = List.from(_allCandidates);
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Lógica de filtro e busca ─────────────────────────────────────
  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredCandidates = _allCandidates.where((candidate) {
        final matchesSearch = query.isEmpty ||
            candidate.name.toLowerCase().contains(query) ||
            candidate.email.toLowerCase().contains(query) ||
            candidate.course.toLowerCase().contains(query) ||
            candidate.technicalSkills
                .any((s) => s.toLowerCase().contains(query)) ||
            candidate.softSkills.any((s) => s.toLowerCase().contains(query));

        final matchesFilter = _availabilityFilter == null ||
            candidate.available == _availabilityFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _setFilter(bool? value) {
    setState(() {
      _availabilityFilter = value;
    });
    _applyFilters();
  }

  // ── Ações de candidato ───────────────────────────────────────────
  Future<void> _navigateToCreate() async {
    final newCandidate = await context.push<Candidate>(AppRoutes.createCandidate);
    if (newCandidate != null) {
      setState(() {
        _allCandidates = [..._allCandidates, newCandidate];
      });
      _applyFilters();
    }
  }

  Future<void> _navigateToEdit(Candidate candidate) async {
    final updated = await context.push<Candidate>(
      AppRoutes.editCandidate,
      extra: candidate,
    );
    if (updated != null) {
      setState(() {
        _allCandidates = _allCandidates
            .map((c) => c.id == updated.id ? updated : c)
            .toList();
      });
      _applyFilters();
    }
  }

  void _deleteCandidate(Candidate candidate) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: const Text('Remover Candidato',
            style: AppTheme.headingMedium),
        content: Text(
          'Deseja remover ${candidate.name} da lista?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _allCandidates.removeWhere((c) => c.id == candidate.id);
              });
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${candidate.name} removido(a).'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    textColor: AppTheme.primaryLight,
                    onPressed: () {
                      setState(() {
                        _allCandidates = [..._allCandidates, candidate];
                      });
                      _applyFilters();
                    },
                  ),
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(innerBoxIsScrolled),
        ],
        body: Column(
          children: [
            if (_isSearchVisible) _buildSearchBar(),
            _buildFilterChips(),
            _buildResultCount(),
            Expanded(
              child: _filteredCandidates.isEmpty
                  ? _buildEmptyState()
                  : _buildCandidateList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(
          'Novo Candidato',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ── Widgets auxiliares ───────────────────────────────────────────
  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.headerGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Candidatos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_allCandidates.length} cadastrado(s)',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: innerBoxIsScrolled
            ? const Text('Candidatos')
            : null,
        collapseMode: CollapseMode.parallax,
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
            color: Colors.white,
          ),
          tooltip: 'Pesquisar',
          onPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) {
                _searchController.clear();
              }
            });
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingM, AppTheme.spacingM, AppTheme.spacingM, 0),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: AppTheme.inputDecoration(
          label: 'Pesquisar candidatos...',
          icon: Icons.search_rounded,
          hint: 'Nome, e-mail, habilidade...',
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingM, AppTheme.spacingS, AppTheme.spacingM, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'Todos',
              icon: Icons.people_rounded,
              selected: _availabilityFilter == null,
              onTap: () => _setFilter(null),
            ),
            const SizedBox(width: AppTheme.spacingS),
            _FilterChip(
              label: 'Disponíveis',
              icon: Icons.check_circle_rounded,
              selected: _availabilityFilter == true,
              activeColor: AppTheme.success,
              onTap: () => _setFilter(true),
            ),
            const SizedBox(width: AppTheme.spacingS),
            _FilterChip(
              label: 'Indisponíveis',
              icon: Icons.cancel_rounded,
              selected: _availabilityFilter == false,
              activeColor: AppTheme.error,
              onTap: () => _setFilter(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingM, AppTheme.spacingS, AppTheme.spacingM, AppTheme.spacingXS),
      child: Row(
        children: [
          Text(
            '${_filteredCandidates.length} resultado(s)',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingM, 0, AppTheme.spacingM, 90),
      itemCount: _filteredCandidates.length,
      itemBuilder: (context, index) {
        return _CandidateCard(
          candidate: _filteredCandidates[index],
          onEdit: () => _navigateToEdit(_filteredCandidates[index]),
          onDelete: () => _deleteCandidate(_filteredCandidates[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text('Nenhum candidato encontrado',
                style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingS),
            const Text(
              'Tente ajustar os filtros ou a pesquisa.',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget: Card de candidato ────────────────────────────────────────
class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.candidate,
    required this.onEdit,
    required this.onDelete,
  });

  final Candidate candidate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(child: _buildInfo()),
                _buildStatusBadge(),
              ],
            ),

            const SizedBox(height: AppTheme.spacingM),
            const Divider(color: AppTheme.divider, height: 1),
            const SizedBox(height: AppTheme.spacingS),

            // Habilidades técnicas
            _buildSkillSection(
              'Técnicas',
              candidate.technicalSkills,
              AppTheme.primary,
            ),

            const SizedBox(height: AppTheme.spacingS),

            // Soft Skills
            _buildSkillSection(
              'Soft Skills',
              candidate.softSkills,
              AppTheme.accent,
            ),

            const SizedBox(height: AppTheme.spacingS),
            const Divider(color: AppTheme.divider, height: 1),

            // Ações
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: AppTheme.error),
                  label: const Text('Remover',
                      style: TextStyle(color: AppTheme.error, fontSize: 13)),
                  onPressed: onDelete,
                ),
                const SizedBox(width: AppTheme.spacingS),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 38),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  onPressed: onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppTheme.cardAccentGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          candidate.name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(candidate.name, style: AppTheme.headingSmall),
        const SizedBox(height: 2),
        Text(candidate.email, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.school_rounded, size: 12, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${candidate.course} • ${candidate.graduationYear}',
                style: AppTheme.bodyMedium.copyWith(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final isAvailable = candidate.available;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppTheme.success.withOpacity(0.12)
            : AppTheme.error.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: isAvailable
              ? AppTheme.success.withOpacity(0.4)
              : AppTheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.circle : Icons.circle,
            size: 6,
            color: isAvailable ? AppTheme.success : AppTheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'Disponível' : 'Ocupado',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isAvailable ? AppTheme.success : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSection(
      String title, List<String> skills, Color color) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTheme.labelSmall.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: skills
              .take(6)
              .map((skill) => _SkillChip(label: skill, color: color))
              .toList()
            ..addAll(skills.length > 6
                ? [
                    _SkillChip(
                      label: '+${skills.length - 6}',
                      color: AppTheme.textSecondary,
                    )
                  ]
                : []),
        ),
      ],
    );
  }
}

// ── Widget: Chip de habilidade ───────────────────────────────────────
class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ── Widget: Filtro chip customizado ─────────────────────────────────
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.activeColor = AppTheme.primary,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? activeColor : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: selected ? activeColor : AppTheme.divider,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: selected ? Colors.white : AppTheme.textSecondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
