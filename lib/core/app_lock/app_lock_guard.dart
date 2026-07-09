import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ntfyd/core/app_lock/app_lock_service.dart';
import 'package:ntfyd/core/usecase/result.dart';

class AppLockGuard extends StatefulWidget {
  const AppLockGuard({
    super.key,
    required this.biometricLock,
    required this.hideLockScreenContent,
    required this.appLockService,
    required this.child,
    this.lockTimeout = const Duration(minutes: 10),
    this.now = DateTime.now,
  });

  final bool biometricLock;
  final bool hideLockScreenContent;
  final AppLockService appLockService;
  final Widget child;

  /// How long a successful authentication stays valid. A `resumed` event
  /// within this window (e.g. the biometric prompt's own dialog closing)
  /// does not require re-authentication.
  final Duration lockTimeout;

  final DateTime Function() now;

  @override
  State<AppLockGuard> createState() => _AppLockGuardState();
}

class _AppLockGuardState extends State<AppLockGuard>
    with WidgetsBindingObserver {
  bool _locked = false;
  int _failedAttempts = 0;
  bool _authenticating = false;
  DateTime? _lastAuthenticatedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.biometricLock) {
      _lock();
    }
  }

  @override
  void didUpdateWidget(covariant AppLockGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.biometricLock && widget.biometricLock) {
      _lock();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !widget.biometricLock) return;

    final lastAuthenticatedAt = _lastAuthenticatedAt;
    if (lastAuthenticatedAt != null &&
        widget.now().difference(lastAuthenticatedAt) < widget.lockTimeout) {
      return;
    }
    _lock();
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
        _lastAuthenticatedAt = widget.now();
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
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: widget.hideLockScreenContent
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    )
                  : const SizedBox.expand(),
            ),
          ),
        if (_locked)
          Positioned.fill(
            child: Center(
              child: Card(
                key: const Key('lock_overlay'),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'App Locked',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _failedAttempts == 0
                            ? 'Authenticate to continue'
                            : 'Authentication failed. Try again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _authenticating ? null : _authenticate,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(
                          _authenticating ? 'Authenticating...' : 'Unlock',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
