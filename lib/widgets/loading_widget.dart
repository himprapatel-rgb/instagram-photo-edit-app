/// Loading Widget
/// Professional loading indicators

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showMessage;
  
  const LoadingWidget({
    super.key,
    this.message,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          if (showMessage) ..[
            const SizedBox(height: AppTheme.spaceLarge),
            Text(
              message ?? 'Loading...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
