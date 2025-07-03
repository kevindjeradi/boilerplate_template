import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../exceptions/auth_exceptions.dart';
import '../extensions/exception_extensions.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text(
        localization.signOut,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: () async {
        // Fermer le popup s'il y en a un ouvert
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        try {
          await ref.read(authControllerProvider.notifier).signOut();
        } on AuthException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toLocalizedMessage(context)),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}
