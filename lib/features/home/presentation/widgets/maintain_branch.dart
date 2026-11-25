import 'package:flutter/material.dart';

class BranchUnderMaintenance extends StatelessWidget {
  const BranchUnderMaintenance({
    super.key,
    required this.onViewOtherBranches,
  });

  final VoidCallback onViewOtherBranches;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.build_rounded,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),

            Text(
              'Branch is under maintenance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'This branch is currently unavailable. You can view other branches.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Button
            ElevatedButton(
              onPressed: onViewOtherBranches,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('View Other Branches'),
            ),
          ],
        ),
      ),
    );
  }
}
