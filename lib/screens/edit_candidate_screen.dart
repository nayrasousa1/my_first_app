import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/models/candidate.dart';
import 'package:my_first_app/theme/app_theme.dart';

class EditCandidateScreen extends StatefulWidget {
  const EditCandidateScreen({super.key, required this.candidate});

  final Candidate candidate;

  @override
  State<EditCandidateScreen> createState() => _EditCandidateScreenState();
}

class _EditCandidateScreenState extends State<EditCandidateScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _documentController;
  late final TextEditingController _emailController;
  late final TextEditingController _courseController;
  late final TextEditingController _graduationYearController;
  final _technicalSkillController = TextEditingController();
  final _softSkillController = TextEditingController();

  late bool _available;
  late List<String> _technicalSkills;
  late List<String> _softSkills;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Pré-preenche os campos com os dados do candidato
    final c = widget.candidate;
    _nameController = TextEditingController(text: c.name);
    _documentController = TextEditingController(text: c.document);
    _emailController = TextEditingController(text: c.email);
    _courseController = TextEditingController(text: c.course);
    _graduationYearController =
        TextEditingController(text: c.graduationYear.toString());
    _available = c.available;
    _technicalSkills = List.from(c.technicalSkills);
    _softSkills = List.from(c.softSkills);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _graduationYearController.dispose();
    _technicalSkillController.dispose();
    _softSkillController.dispose();
    super.dispose();
  }

  // ── Habilidades ──────────────────────────────────────────────────
  void _addTechnicalSkill() {
    final value = _technicalSkillController.text.trim();
    if (value.isNotEmpty && !_technicalSkills.contains(value)) {
      setState(() {
        _technicalSkills.add(value);
        _technicalSkillController.clear();
      });
    }
  }

  void _removeTechnicalSkill(String skill) =>
      setState(() => _technicalSkills.remove(skill));

  void _addSoftSkill() {
    final value = _softSkillController.text.trim();
    if (value.isNotEmpty && !_softSkills.contains(value)) {
      setState(() {
        _softSkills.add(value);
        _softSkillController.clear();
      });
    }
  }

  void _removeSoftSkill(String skill) =>
      setState(() => _softSkills.remove(skill));

  // ── Salvar edição ────────────────────────────────────────────────
  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _currentStep = 0);
      return;
    }

    final updated = widget.candidate.copyWith(
      name: _nameController.text.trim(),
      document: _documentController.text.trim(),
      email: _emailController.text.trim(),
      course: _courseController.text.trim(),
      graduationYear: int.parse(_graduationYearController.text.trim()),
      available: _available,
      technicalSkills: List.from(_technicalSkills),
      softSkills: List.from(_softSkills),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Candidato atualizado com sucesso! ✅')),
    );

    Navigator.pop(context, updated);
  }

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [_buildHeader()],
          body: _buildStepper(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFFE91E8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Editar Candidato',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.candidate.name,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: _currentStep > 0
            ? Text('Editando: ${widget.candidate.name}',
                overflow: TextOverflow.ellipsis)
            : null,
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildStepper() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: AppTheme.accent),
      ),
      child: Stepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _saveChanges();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: AppTheme.spacingM),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                  ),
                  onPressed: details.onStepContinue,
                  child: Text(
                    _currentStep == 2 ? 'Salvar Alterações' : 'Continuar',
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: OutlinedButton(
                  onPressed: details.onStepCancel,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    side: const BorderSide(color: AppTheme.divider),
                  ),
                  child: Text(
                    _currentStep == 0 ? 'Cancelar' : 'Voltar',
                    style:
                        const TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        steps: [
          _buildStep(
            index: 0,
            title: 'Dados Pessoais',
            subtitle: 'Nome, CPF e e-mail',
            content: _buildPersonalDataStep(),
          ),
          _buildStep(
            index: 1,
            title: 'Formação',
            subtitle: 'Curso, ano e disponibilidade',
            content: _buildFormationStep(),
          ),
          _buildStep(
            index: 2,
            title: 'Habilidades',
            subtitle: 'Técnicas e comportamentais',
            content: _buildSkillsStep(),
          ),
        ],
      ),
    );
  }

  Step _buildStep({
    required int index,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    return Step(
      isActive: _currentStep >= index,
      state: _currentStep > index ? StepState.complete : StepState.indexed,
      title: Text(title, style: AppTheme.headingSmall),
      subtitle:
          Text(subtitle, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
      content: content,
    );
  }

  // ── Conteúdo dos steps (idêntico ao CreateScreen, reutilizável) ──
  Widget _buildPersonalDataStep() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: AppTheme.inputDecoration(
            label: 'Nome Completo',
            icon: Icons.person_outline_rounded,
          ),
          textCapitalization: TextCapitalization.words,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Informe o nome completo'
              : null,
        ),
        const SizedBox(height: AppTheme.spacingM),
        TextFormField(
          controller: _documentController,
          decoration: AppTheme.inputDecoration(
            label: 'CPF',
            icon: Icons.badge_outlined,
            hint: '000.000.000-00',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Informe o CPF' : null,
        ),
        const SizedBox(height: AppTheme.spacingM),
        TextFormField(
          controller: _emailController,
          decoration: AppTheme.inputDecoration(
            label: 'E-mail',
            icon: Icons.email_outlined,
            hint: 'exemplo@email.com',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
            if (!v.contains('@') || !v.contains('.')) {
              return 'E-mail inválido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFormationStep() {
    return Column(
      children: [
        TextFormField(
          controller: _courseController,
          decoration: AppTheme.inputDecoration(
            label: 'Curso',
            icon: Icons.school_outlined,
          ),
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Informe o curso' : null,
        ),
        const SizedBox(height: AppTheme.spacingM),
        TextFormField(
          controller: _graduationYearController,
          decoration: AppTheme.inputDecoration(
            label: 'Ano de Conclusão',
            icon: Icons.calendar_today_rounded,
            hint: '2026',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Informe o ano';
            final year = int.tryParse(v);
            if (year == null || year < 2000 || year > 2100) {
              return 'Ano inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.divider),
          ),
          child: SwitchListTile(
            secondary: Icon(
              _available ? Icons.work_rounded : Icons.work_off_rounded,
              color: _available ? AppTheme.success : AppTheme.textSecondary,
            ),
            title: const Text(
              'Disponível para contratação',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              _available
                  ? 'Sim, disponível agora'
                  : 'Não disponível no momento',
              style: TextStyle(
                fontSize: 12,
                color:
                    _available ? AppTheme.success : AppTheme.textSecondary,
              ),
            ),
            value: _available,
            activeColor: AppTheme.success,
            onChanged: (value) => setState(() => _available = value),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkillInput(
          label: 'Habilidade Técnica',
          icon: Icons.code_rounded,
          hint: 'Ex: Flutter, React, PHP...',
          controller: _technicalSkillController,
          onAdd: _addTechnicalSkill,
          skills: _technicalSkills,
          onRemove: _removeTechnicalSkill,
          color: AppTheme.primary,
        ),
        const SizedBox(height: AppTheme.spacingL),
        _buildSkillInput(
          label: 'Soft Skill',
          icon: Icons.people_rounded,
          hint: 'Ex: Liderança, Comunicação...',
          controller: _softSkillController,
          onAdd: _addSoftSkill,
          skills: _softSkills,
          onRemove: _removeSoftSkill,
          color: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _buildSkillInput({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required VoidCallback onAdd,
    required List<String> skills,
    required void Function(String) onRemove,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: AppTheme.headingSmall.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration:
                    AppTheme.inputDecoration(label: hint, icon: icon),
                onSubmitted: (_) => onAdd(),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.add_rounded, color: Colors.white),
                onPressed: onAdd,
              ),
            ),
          ],
        ),
        if (skills.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingS),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skills
                .map((skill) => _RemovableChip(
                      label: skill,
                      color: color,
                      onRemove: () => onRemove(skill),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ── Widget: Chip removível ───────────────────────────────────────────
class _RemovableChip extends StatelessWidget {
  const _RemovableChip({
    required this.label,
    required this.color,
    required this.onRemove,
  });

  final String label;
  final Color color;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14, color: color),
          ),
        ],
      ),
    );
  }
}
