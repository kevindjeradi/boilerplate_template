import 'package:flutter/material.dart';
import 'package:boilerplate_template/shared/constants/assets.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de l'app
            Image.asset(
              Assets.logo,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            // Indicateur de chargement
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Chargement...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
