import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/feed/presentation/pages/home_page.dart';
import 'package:ntfyd/features/server_config/presentation/failure_message.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_form_state.dart';

/// First-run login facade (D14: health-only validation on Connect).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ServerFormCubit, ServerFormState>(
      listener: (context, state) {
        switch (state) {
          case ServerFormSuccess():
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (_) => const HomePage()),
            );
          case ServerFormError(failure: final failure):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(friendlyFailureMessage(failure))),
            );
          case ServerFormIdle():
          case ServerFormValidating():
            break;
        }
      },
      builder: (context, state) {
        final isValidating = state is ServerFormValidating;

        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ntfyd',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Self-hosted & public notification client',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 64),
                        TextFormField(
                          controller: _urlController,
                          enabled: !isValidating,
                          decoration: const InputDecoration(
                            hintText: 'Server URL (default:https://ntfy.sh)',
                            border: InputBorder.none
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _userController,
                          enabled: !isValidating,
                          decoration: const InputDecoration(
                            hintText: 'Username',
                            border: InputBorder.none
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !isValidating,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            onPressed: isValidating
                                ? null
                                : () => context
                                .read<ServerFormCubit>()
                                .connect(
                              url: _urlController.text,
                              user: _userController.text,
                              password: _passwordController.text,
                            ),
                            child: isValidating
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                                : const Text('Connect'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Supports self-hosted servers',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}