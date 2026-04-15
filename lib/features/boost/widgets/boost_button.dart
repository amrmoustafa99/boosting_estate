import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/boost_selection_state.dart';

class BoostButton extends StatelessWidget {
  final BoostSelectionState state;
  final VoidCallback onBoost;

  const BoostButton({super.key, required this.state, required this.onBoost});

  @override
  Widget build(BuildContext context) {
    final isEnabled = state.hasSelection;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.45,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? onBoost : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary, // ثابت في كل الحالات
              disabledBackgroundColor: AppTheme.primary, // برضه نفس اللون
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.rocket_launch_rounded,
                  size: 20,
                  color: AppTheme.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  isEnabled
                      ? 'Boost Now  •  \$${state.totalPrice.toStringAsFixed(2)}'
                      : 'Select an option to boost',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
