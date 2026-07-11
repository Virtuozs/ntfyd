# ntfyd

A Flutter client for [ntfy](https://ntfy.sh) notification servers that works with the public `ntfy.sh` service or your own self-hosted ntfy instance.

**Docs:** [Home](README.md) · [App Walkthrough](APP_WALKTHROUGH.md)

---

## What is ntfyd?

ntfy is a simple pub-sub notification service: you publish a message to a "topic" and anyone subscribed to that topic gets notified. ntfyd is a mobile client for it, letting you:

- Subscribe to one or more topics on any ntfy-compatible server
- Receive push notifications for new messages, delivered via Firebase Cloud Messaging or a foreground service
- Publish messages/notifications to a topic directly from the app
- Organize topics into groups/tags for easier management
- Connect to multiple servers (public `ntfy.sh` and/or self-hosted instances) from a single app
- Lock the app behind biometric/device authentication
- Customize themes, notification priority rules, quiet hours, and cache/privacy settings

It's built for personal use, development notifications, and organizational alerting workflows.

## Architecture

Clean Architecture · Bloc/Cubit (`flutter_bloc`) · Drift (local SQLite cache) · Hybrid delivery (Android Foreground Service)

Each feature (`feed`, `groups`, `subscription`, `publish`, `server_config`, `settings`, `notifications`) is organized into `data` / `domain` / `presentation` layers under `lib/features/`, with shared infrastructure (database, network, DI) under `lib/core/`.

### Authentication model

ntfyd does not implement its own user accounts or authentication system. It follows ntfy's model, where authentication and authorization are handled entirely by the configured ntfy-compatible server.

- Adding or updating a server performs a health check against the server URL to confirm it's reachable, operational, and compatible — this is **not** a login and creates no app-level session.
- Credentials are only used when interacting with protected resources (topics) that require them; the server validates credentials and enforces access.

## Getting started

### Requirements

- Flutter SDK compatible with Dart `^3.12.1`
- Android Studio / Xcode toolchains for your target platform
- A running ntfy server to test against — either `https://ntfy.sh` or a [self-hosted instance](https://docs.ntfy.sh/install/)

### Setup

```bash
flutter pub get
flutter run
```

## Design

[View the Figma project](https://www.figma.com/design/w5ReqplnrVOWVD2LZg1egU/ntfyd?node-id=6-2&p=f&t=cTwifG3Nl0FwnO8n-0)

## See it in action

For a full screenshot walkthrough of the app from first launch through login, feeds, subscriptions, notifications, and settings — see [APP_WALKTHROUGH.md](APP_WALKTHROUGH.md).
