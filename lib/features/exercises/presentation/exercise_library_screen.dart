import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/exercise_thumbnail.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../data/models/exercise_model.dart';
import 'exercise_details_screen.dart';
import 'exercise_provider.dart';

class ExerciseLibraryScreen extends StatelessWidget {
  final bool isPickerMode;
  final ValueChanged<ExerciseModel>? onExerciseSelected;

  const ExerciseLibraryScreen({
    super.key,
    this.isPickerMode = false,
    this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseProvider>();
    final exercises = provider.filteredExercises;

    return BackgroundScaffold(
      appBar: CustomAppBar(
        title: 'Exercise Library',
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryWhite),
            onPressed: () => _showFilterBottomSheet(context, provider),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search Bar
            GlassInput(
              hintText: 'Search exercises...',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (val) => provider.setSearchQuery(val),
            ),
            const SizedBox(height: 14),

            // Filter Chips Row: All, Free, Muscle Groups
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.muscleGroups.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final group = provider.muscleGroups[idx];
                  final isSelected = provider.selectedMuscleGroup == group;
                  return ChoiceChip(
                    label: Text(group),
                    selected: isSelected,
                    onSelected: (_) => provider.selectMuscleGroup(group),
                    selectedColor: AppColors.electricBlue,
                    backgroundColor: AppColors.glassBlue.withOpacity(0.5),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryWhite
                          : AppColors.mutedBlue,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.cyan
                            : AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 2-Column Grid
            Expanded(
              child: exercises.isEmpty
                  ? Center(
                      child: Text(
                        'No exercises found matching your search.',
                        style: AppTypography.bodyMedium,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: exercises.length,
                      itemBuilder: (context, idx) {
                        final ex = exercises[idx];
                        return GlassCard(
                          padding: const EdgeInsets.all(10),
                          onTap: () {
                            if (isPickerMode && onExerciseSelected != null) {
                              onExerciseSelected!(ex);
                            } else {
                              provider.selectExercise(ex);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ExerciseDetailsScreen(exercise: ex),
                                ),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ExerciseThumbnail(
                                  exerciseName: ex.name,
                                  borderRadius: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ex.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ex.equipment,
                                style: AppTypography.labelSmall,
                              ),
                            ],
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

  void _showFilterBottomSheet(
    BuildContext context,
    ExerciseProvider provider,
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
            Text('Filter Muscle Groups', style: AppTypography.headingMedium),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.muscleGroups.map((g) {
                final isSelected = provider.selectedMuscleGroup == g;
                return ChoiceChip(
                  label: Text(g),
                  selected: isSelected,
                  selectedColor: AppColors.electricBlue,
                  onSelected: (_) {
                    provider.selectMuscleGroup(g);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
