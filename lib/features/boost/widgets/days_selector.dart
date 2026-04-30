import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';

class DaysSelector extends StatelessWidget {
  final List<DurationOption> options;
  final DurationOption? selected;
  final ValueChanged<DurationOption> onSelect;

  const DaysSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final isSelected = selected?.days == option.days;
          return GestureDetector(
            onTap: () => onSelect(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${option.days}d',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${option.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withOpacity(0.85)
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${option.units} unit${option.units > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withOpacity(0.65)
                          : AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
