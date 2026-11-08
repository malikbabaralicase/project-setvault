import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../data/models/workout_routine_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../authentication/presentation/auth_provider.dart';
import '../../exercises/presentation/exercise_library_screen.dart';
import '../../timer/presentation/rest_timer_screen.dart';
import 'routine_provider.dart';

class CreateRoutineScreen extends StatefulWidget {
  final WorkoutRoutineModel? existingRoutine;

  const CreateRoutineScreen({
    super.key,
    this.existingRoutine,
  });

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  late TextEditingController _titleController;
  late List<WorkoutSetModel> _routineSets;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingRoutine?.title ?? 'Push Day',
    );

    _routineSets = [
      WorkoutSetModel(
        id: 'rs1',
        setNumber: 1,
        previousWeight: 40,
        previousReps: 10,
        weight: 40,
        reps: 10,
        isCompleted: true,
      ),
      WorkoutSetModel(
        id: 'rs2',
        setNumber: 2,
        previousWeight: 40,
        previousReps: 9,
        weight: 40,
        reps: 9,
        isCompleted: true,
      ),
      WorkoutSetModel(
        id: 'rs3',
        setNumber: 3,
        previousWeight: 25,
        previousReps: 12,
        weight: 25,
        reps: 12,
        isCompleted: true,
      ),
      WorkoutSetModel(
        id: 'rs4',
        setNumber: 4,
        previousWeight: 35,
        previousReps: 10,
        weight: 35,
        reps: 10,
        isCompleted: true,
      ),
      WorkoutSetModel(
        id: 'rs5',
        setNumber: 5,
        previousWeight: 25,
        previousReps: 12,
        weight: 25,
        reps: 12,
        isCompleted: false,
      ),
    ];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addSet() {
    setState(() {
      final last = _routineSets.isNotEmpty ? _routineSets.last : null;
      _routineSets.add(
        WorkoutSetModel(
          id: 'rs_${DateTime.now().millisecondsSinceEpoch}',
          setNumber: _routineSets.length + 1,
          previousWeight: last?.weight ?? 40,
          previousReps: last?.reps ?? 10,
          weight: last?.weight ?? 40,
          reps: last?.reps ?? 10,
          isCompleted: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: CustomAppBar(
        title: widget.existingRoutine != null
            ? 'Edit Routine'
            : 'Create Routine',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Routine Title Input
                  GlassInput(
                    label: 'Routine Name',
                    controller: _titleController,
                    hintText: 'e.g., Push Day, Full Body A',
                  ),

                  const SizedBox(height: 20),

                  // Exercises Header with edit action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Exercises', style: AppTypography.sectionHeading),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.cyan,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseLibraryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Sets Table inside Glass Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Table Header
                        Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text('Set', style: AppTypography.labelSmall),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Previous',
                                style: AppTypography.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Weight',
                                style: AppTypography.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Reps',
                                style: AppTypography.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                'Done',
                                style: AppTypography.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Set Rows
                        ...List.generate(_routineSets.length, (idx) {
                          final s = _routineSets[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${s.setNumber}',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: AppColors.mutedBlue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${s.previousWeight.toInt()} kg × ${s.previousReps}',
                                    style: AppTypography.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 36,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.deepMidnightNavy
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.glassBorderSubtle,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      initialValue: '${s.weight.toInt()}',
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.labelLarge,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        final parsed = double.tryParse(val);
                                        if (parsed != null) s.weight = parsed;
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 36,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.deepMidnightNavy
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.glassBorderSubtle,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      initialValue: '${s.reps}',
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.labelLarge,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val);
                                        if (parsed != null) s.reps = parsed;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 44,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        s.isCompleted = !s.isCompleted;
                                      });
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: s.isCompleted
                                            ? AppColors.success
                                            : AppColors.glassBlue.withOpacity(0.4),
                                        border: Border.all(
                                          color: s.isCompleted
                                              ? AppColors.success
                                              : AppColors.glassBorder,
                                        ),
                                      ),
                                      child: Icon(
                                        s.isCompleted
                                            ? Icons.check_rounded
                                            : Icons.remove_rounded,
                                        size: 16,
                                        color: s.isCompleted
                                            ? AppColors.deepMidnightNavy
                                            : AppColors.mutedBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 12),

                        // Action links
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _addSet,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add_rounded,
                                    color: AppColors.cyan,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Add Set',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RestTimerScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: AppColors.mutedBlue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Rest Timer',
                                    style: AppTypography.labelMedium,
                                  ),
                                ],
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
          ),

          // Bottom Cancel & Save Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.darkNavy.withOpacity(0.9),
              border: const Border(
                top: BorderSide(color: AppColors.glassBorderSubtle),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GlassButton(
                    text: 'Cancel',
                    type: GlassButtonType.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GlassButton(
                    text: 'Save',
                    type: GlassButtonType.primary,
                    onPressed: () {
                      final provider = context.read<RoutineProvider>();
                      final auth = context.read<AuthProvider>();
                      final uid = auth.currentUser?.id ?? 'user_alex_01';
                      provider.addRoutine(
                        uid,
                        WorkoutRoutineModel(
                          id: 'rt_${DateTime.now().millisecondsSinceEpoch}',
                          title: _titleController.text.toUpperCase(),
                          totalWorkouts: 1,
                          trainingVolumeKg: 4200,
                          exercises: const [],
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Routine saved successfully!'),
                          backgroundColor: AppColors.glassBlue,
                        ),
                      );
                    },
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

