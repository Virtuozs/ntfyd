import 'package:flutter/material.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/usecase/result.dart';

class AppLockGuard extends StatefulWidget {
  const AppLockGuard({
    super.key,
    required this.biometricLock,
    required this.appLockService,
    required this.child,
  });

  final bool biometricLock;
  final AppLockService appLockService;
  final Widget child;

  @override
  State<AppLockGuard> createState() => _AppLockGuardState();
}

class _AppLockGuardState extends State<AppLockGuard>
    with WidgetsBindingObserver {
  static const _maxAttempts = 3;

  bool _locked = false;
  int _failedAttempts = 0;
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && widget.biometricLock) {
      _lock();
    }
  }

  void _lock() {
    setState(() {
      _locked = true;
    });
    _authenticate();
  }

  Future<void> _authenticate() async {
    if (_authenticating) return;
    _authenticating = true;

    final result = await widget.appLockService.authenticate(
      'Unlock ntfyd to continue',
    );
    if (!mounted) return;

    _authenticating = false;

    result.when(
      success: (_) {
        setState(() {
          _locked = false;
          _failedAttempts = 0;
        });
      },
      err: (failure) {
        setState(() {
          _failedAttempts++;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_locked)
          _LockOverlay(
            key: const Key('lock_overlay'),
            showPinFallback: _failedAttempts >= _maxAttempts,
            onRetry: _authenticate,
          ),
      ],
    );
  }
}

class _LockOverlay extends StatelessWidget {
  const _LockOverlay({
    super.key,
    required this.showPinFallback,
    required this.onRetry,
  });

  final bool showPinFallback;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 24),
            const Text('App locked'),
            const SizedBox(height: 16),
            if (showPinFallback)
              TextButton(
                onPressed: onRetry,
                child: const Text('Use device PIN'),
              )
            else
              FilledButton(onPressed: onRetry, child: const Text('Unlock')),
          ],
        ),
      ),
    );
  }
}
