import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/widgets/email_auth_form.dart';
import 'package:boilerplate_template/features/auth/widgets/phone_auth_form.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:boilerplate_template/shared/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreenMobile extends ConsumerStatefulWidget {
  const AuthScreenMobile({super.key});

  @override
  ConsumerState<AuthScreenMobile> createState() => _AuthScreenMobileState();
}

class _AuthScreenMobileState extends ConsumerState<AuthScreenMobile> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _showEmailForm = false;
  bool _showPhoneForm = false;

  void _resetForms() {
    setState(() {
      _showEmailForm = false;
      _showPhoneForm = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 500 ? 500.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.authenticate),
        leading: (_showEmailForm || _showPhoneForm)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _resetForms,
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: context.paddingLarge,
                  bottom: context.paddingLarge * 1.5,
                ),
                child: Image.asset(
                  Assets.logo,
                  height: 160,
                  width: 160,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: Card(
                  elevation: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Formulaire Email avec animation
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            offset: _showEmailForm
                                ? Offset.zero
                                : const Offset(1.0, 0.0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _showEmailForm ? 1.0 : 0.0,
                              child: Padding(
                                padding: EdgeInsets.all(context.paddingLarge),
                                child: const EmailAuthForm(),
                              ),
                            ),
                          ),
                          // Formulaire Phone avec animation
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            offset: _showPhoneForm
                                ? Offset.zero
                                : const Offset(1.0, 0.0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _showPhoneForm ? 1.0 : 0.0,
                              child: Padding(
                                padding: EdgeInsets.all(context.paddingLarge),
                                child: const PhoneAuthForm(),
                              ),
                            ),
                          ),
                          // Menu principal avec animation
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            offset: !_showEmailForm && !_showPhoneForm
                                ? Offset.zero
                                : const Offset(-1.0, 0.0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: !_showEmailForm && !_showPhoneForm
                                  ? 1.0
                                  : 0.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.paddingLarge,
                                  vertical: context.paddingLarge * 1.5,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (_errorMessage != null) ...[
                                        Text(
                                          _errorMessage!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: colorScheme.error),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: context.marginMedium),
                                      ],
                                      FilledButton.icon(
                                        onPressed: _isLoading
                                            ? null
                                            : () async {
                                                setState(() {
                                                  _isLoading = true;
                                                  _errorMessage = null;
                                                });

                                                final error = await ref
                                                    .read(authControllerProvider
                                                        .notifier)
                                                    .signInWithGoogle();

                                                if (mounted) {
                                                  setState(() {
                                                    _isLoading = false;
                                                    if (error != null) {
                                                      _errorMessage = error
                                                          .toLocalizedMessage(
                                                              context);
                                                    }
                                                  });
                                                }
                                              },
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black87,
                                          elevation: 1,
                                          padding: EdgeInsets.symmetric(
                                            vertical: context.paddingMedium,
                                          ),
                                        ),
                                        icon: _isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Image.asset(
                                                Assets.googleLogo,
                                                height: context.iconSizeSmall,
                                                width: context.iconSizeSmall,
                                              ),
                                        label:
                                            Text(localization.signInWithGoogle),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: context.paddingLarge,
                                        ),
                                        child: Row(
                                          children: [
                                            const Expanded(child: Divider()),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      context.paddingMedium),
                                              child: Text(
                                                localization.or,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: colorScheme
                                                            .outline),
                                              ),
                                            ),
                                            const Expanded(child: Divider()),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () => setState(
                                            () => _showEmailForm = true),
                                        icon: const Icon(Icons.email_outlined),
                                        label: Text(
                                            localization.continueWithEmail),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: context.paddingMedium,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: context.marginMedium),
                                      OutlinedButton.icon(
                                        onPressed: () => setState(
                                            () => _showPhoneForm = true),
                                        icon: const Icon(Icons.phone_outlined),
                                        label: Text(
                                            localization.continueWithPhone),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: context.paddingMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
