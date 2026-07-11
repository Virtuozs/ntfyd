# App Walkthrough

**Docs:** [Home](README.md) · [App Walkthrough](APP_WALKTHROUGH.md)

A visual tour of ntfyd, screen by screen.

---

## 1. First launch

On first launch, ntfyd greets you with a fresh install and no servers configured yet.

![First app launch](readme_assets/screenshots/001-first-app-launch.png)

## 2. Logging in to a server

"Logging in" here means adding and validating an ntfy-compatible server, see [Authentication model](README.md#authentication-model) for how this differs from a traditional login.

| Failed health check | Login form | Success |
|---|---|---|
| ![Login failed](readme_assets/screenshots/003-login-page-failed.png) | ![Login page](readme_assets/screenshots/003-login-page.png) | ![Login success](readme_assets/screenshots/004-login-page-success.png) |

## 3. The feed

Once connected, the home feed lists your subscribed topics and their latest activity.

![Feed homepage](readme_assets/screenshots/005-feed-homepage.png)

### Tags and groups

Topics can be organized into tags/groups for easier navigation.

| Tag list | Create new tag |
|---|---|
| ![Feed tag list](readme_assets/screenshots/006-feed-tag-list.png) | ![Create new tag](readme_assets/screenshots/007-feed-create-new-tag.png) |

### Subscribing to a topic

Use the floating action button to subscribe to a new topic.

| FAB collapsed | Subscribe sheet | Filled in |
|---|---|---|
| ![FAB collapsed](readme_assets/screenshots/008-feed-fab-collapsed.png) | ![Subscribe to topic](readme_assets/screenshots/009-feed-subsribe-to-topic.png) | ![Filled subscribe form](readme_assets/screenshots/010-feed-filled-subscribe-to-topic.png) |

Once subscribed, the topic appears on the home feed and can be managed from its context menu.

| Feed with topic | Topic menu |
|---|---|
| ![Feed with topic](readme_assets/screenshots/011-feed-homepage-with-topic.png) | ![Topic menu](readme_assets/screenshots/012-feed-specific-topic-menu.png) |

## 4. Messaging a topic

Opening a topic shows its message history in real time.

![Topic detail page](readme_assets/screenshots/013-feed-detail-page.png)

Incoming messages are caught live over the topic's connection...

![Message caught in feed](readme_assets/screenshots/014-feed-catch-message.png)

...and delivered as a device notification.

![Receiving a notification](readme_assets/screenshots/015-receiving-notification.png)

You can also publish messages to a topic directly from the app.

| Sending a message | Message received |
|---|---|
| ![Send message](readme_assets/screenshots/016-detail-feed-send-message.png) | ![Message received](readme_assets/screenshots/017-detail-feed-message-received.png) |

## 5. Settings

The settings page is the hub for servers, appearance, security, notifications, storage, and privacy.

![Settings page](readme_assets/screenshots/018-settings-page.png)

### Server manager

Manage every connected server — public or self-hosted — from one place.

![Server manager page](readme_assets/screenshots/019-server-manager-page.png)

### Theme

Pick a color theme, including dynamic/Material You color support.

![Theme selector page](readme_assets/screenshots/020-theme-selector-page.png)

### Biometric lock

Lock the app behind device biometrics or a PIN.

![Biometric page](readme_assets/screenshots/021-biometric-page.png)

### Notification settings

Configure delivery behavior, priority channels, and quiet hours per topic.

![Notification settings page](readme_assets/screenshots/022-notificatiion-setting-page.png)

### Cache and sync

Control how much message history is cached locally and how sync behaves.

![Cache sync page](readme_assets/screenshots/023-cache-sync-page.png)

### Privacy

Manage privacy-related preferences and data controls.

![Privacy setting page](readme_assets/screenshots/024-privacy-setting-page.png)
