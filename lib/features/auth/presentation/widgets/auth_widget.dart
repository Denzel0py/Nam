import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? submitButton;
  final Widget? footer;

  const AuthWidget({
    super.key,
    required this.title,
    required this.children,
    this.submitButton,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ...children,
                if (submitButton != null) ...[
                  const SizedBox(height: 24),
                  submitButton!,
                ],
                if (footer != null) ...[
                  const SizedBox(height: 16),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
