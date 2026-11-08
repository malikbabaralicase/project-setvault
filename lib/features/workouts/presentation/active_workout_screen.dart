import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/workout_set_model.dart';
import '../../authentication/presentation/auth_provider.dart';
import '../../exercises/presentation/exercise_library_screen.dart';
import '../../timer/presentation/rest_timer_screen.dart';
import 'active_workout_provider.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActiveWorkoutProvider>();
    final auth = context.watch<AuthProvider>();
    final uid = auth.currentUser?.id ?? 'user_alex_01';

    return BackgroundScaffold(
      body: Column(
        children: [
          // Top Header & Timer
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.glassBlue.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primaryWhite,
                          size: 18,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          provider.title,
                          style: AppTypography.headingMedium,
                        ),
                        const SizedBox(height: 2),
                        // Sync Status Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.deepMidnightNavy.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.glassBorderSubtle,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                provider.syncStatusLabel,
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  color: AppColors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
                const SizedBox(height: 10),
                // Large Live Timer Display
                GestureDetector(
                  onTap: () => provider.toggleTimer(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        provider.isRunning
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                        color: AppColors.cyan,
                        size: 26,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        provider.formattedDuration,
                        style: AppTypography.timerDisplay,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        text: 'Finish Workout',
                        type: GlassButtonType.primary,
                        height: 42,
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: AppColors.primaryWhite,
                        ),
                        onPressed: () {
                          _showFinishDialog(context, provider, uid);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassButton(
                        text: 'More Options',
                        type: GlassButtonType.secondary,
                        height: 42,
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          size: 18,
                          color: AppColors.primaryWhite,
                        ),
                        onPressed: () {
                          _showMoreOptionsSheet(context, provider);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.glassBorderSubtle),

          // Scrollable Exercises List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical: 8,
              ),
              itemCount: provider.exercises.length,
              itemBuilder: (context, exIndex) {
                final ex = provider.exercises[exIndex];
                return _buildExerciseCard(context, provider, ex);
              },
            ),
          ),

          // Bottom Bar with Rest Timer & Add Exercise
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
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
                    text: 'Rest Timer',
                    type: GlassButtonType.secondary,
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: AppColors.cyan,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RestTimerScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassButton(
                    text: '+ Exercise',
                    type: GlassButtonType.outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseLibraryScreen(
                            isPickerMode: true,
                            onExerciseSelected: (selectedEx) {
                              provider.addExercise(selectedEx);
                              Navigator.pop(context);
                            },
                          ),
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

  Widget _buildExerciseCard(
    BuildContext context,
    ActiveWorkoutProvider provider,
    dynamic ex,
  ) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Title & Options
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.glassBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppColors.cyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.exercise.name,
                      style: AppTypography.cardTitle,
                    ),
                    Text(
                      ex.exercise.muscleGroup,
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.mutedBlue,
                ),
                color: AppColors.secondaryNavy,
                onSelected: (val) {
                  if (val == 'note') {
                    _showAddNoteDialog(context, provider, ex.id);
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'note',
                    child: Text(
                      'Add Exercise Note',
                      style: TextStyle(color: AppColors.primaryWhite),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Sets Table Header
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
          ...List.generate(ex.sets.length, (setIdx) {
            final WorkoutSetModel set = ex.sets[setIdx];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // Set Number & Set Type Badge
                  SizedBox(
                    width: 32,
                    child: GestureDetector(
                      onTap: () => _showSetTypeSheet(
                        context,
                        provider,
                        ex.id,
                        setIdx,
                        set,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: _getSetTypeColor(set.type).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getSetTypeLabel(set.type, set.setNumber),
                          textAlign: TextAlign.center,
                          style: AppTypography.labelSmall.copyWith(
                            color: _getSetTypeColor(set.type),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Previous Performance
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${set.previousWeight.toInt()} kg × ${set.previousReps}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mutedBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Weight Input Box
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.deepMidnightNavy.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.glassBorderSubtle,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: '${set.weight.toInt()}',
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTypography.labelLarge,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            provider.updateSetWeight(ex.id, setIdx, parsed);
                          }
                        },
                      ),
                    ),
                  ),
                  // Reps Input Box
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.deepMidnightNavy.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.glassBorderSubtle,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: '${set.reps}',
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTypography.labelLarge,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null) {
                            provider.updateSetReps(ex.id, setIdx, parsed);
                          }
                        },
                      ),
                    ),
                  ),
                  // Checkmark / Done Button
                  SizedBox(
                    width: 44,
                    child: GestureDetector(
                      onTap: () {
                        provider.toggleSetCompleted(ex.id, setIdx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: set.isCompleted
                              ? AppColors.success
                              : AppColors.glassBlue.withOpacity(0.5),
                          border: Border.all(
                            color: set.isCompleted
                                ? AppColors.success
                                : AppColors.glassBorder,
                            width: 1.5,
                          ),
                          boxShadow: set.isCompleted
                              ? [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(0.35),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            set.isCompleted
                                ? Icons.check_rounded
                                : Icons.remove_rounded,
                            size: 18,
                            color: set.isCompleted
                                ? AppColors.deepMidnightNavy
                                : AppColors.mutedBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),

          // Add Set & Add Note Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => provider.addSet(ex.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showAddNoteDialog(context, provider, ex.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit_note_rounded,
                        color: AppColors.mutedBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Note',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.mutedBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSetTypeColor(SetType type) {
    switch (type) {
      case SetType.warmup:
        return AppColors.warning;
      case SetType.drop:
        return AppColors.cyan;
      case SetType.failure:
        return AppColors.error;
      case SetType.normal:
        return AppColors.mutedBlue;
    }
  }

  String _getSetTypeLabel(SetType type, int setNumber) {
    switch (type) {
      case SetType.warmup:
        return 'W$setNumber';
      case SetType.drop:
        return 'D$setNumber';
      case SetType.failure:
        return 'F$setNumber';
      case SetType.normal:
        return '$setNumber';
    }
  }

  void _showSetTypeSheet(
    BuildContext context,
    ActiveWorkoutProvider provider,
    String exerciseId,
    int setIndex,
    WorkoutSetModel set,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.glassBorder),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configure Set ${set.setNumber}', style: AppTypography.headingMedium),
            const SizedBox(height: 14),
            Text('Set Type', style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SetType.values.map((t) {
                return ChoiceChip(
                  label: Text(t.name.toUpperCase()),
                  selected: set.type == t,
                  selectedColor: AppColors.electricBlue,
                  onSelected: (_) {
                    provider.updateSetType(exerciseId, setIndex, t);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              title: const Text('Delete This Set', style: TextStyle(color: AppColors.error)),
              onTap: () {
                provider.removeSet(exerciseId, setIndex);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    ActiveWorkoutProvider provider,
    String exerciseId,
  ) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Exercise Note', style: AppTypography.headingMedium),
        content: TextField(
          controller: noteController,
          style: AppTypography.bodyMedium,
          decoration: const InputDecoration(
            hintText: 'e.g., Felt strong, good form',
            hintStyle: TextStyle(color: AppColors.mutedBlue),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedBlue)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () {
              provider.setNote(noteController.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note saved'),
                  backgroundColor: AppColors.glassBlue,
                ),
              );
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primaryWhite)),
          ),
        ],
      ),
    );
  }

  void _showFinishDialog(
    BuildContext context,
    ActiveWorkoutProvider provider,
    String uid,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Finish Workout?', style: AppTypography.headingMedium),
        content: Text(
          'Workout duration: ${provider.formattedDuration}\nAll completed sets will be recorded to your cloud log.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Resume', style: TextStyle(color: AppColors.mutedBlue)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.finishWorkout(uid);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Workout finished and saved!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text(
              'Save & Finish',
              style: TextStyle(color: AppColors.primaryWhite),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptionsSheet(
    BuildContext context,
    ActiveWorkoutProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.glassBorder),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer_rounded, color: AppColors.cyan),
              title: const Text('Open Rest Timer', style: TextStyle(color: AppColors.primaryWhite)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RestTimerScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: AppColors.error),
              title: const Text('Discard Workout', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.pop(ctx);
                await provider.cancelWorkout();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
