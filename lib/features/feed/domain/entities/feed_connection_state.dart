/// Domain-level connection status for one (serverId, topic) live feed
/// session — mapped from [WsState] by the data layer so `domain/` stays
/// free of `web_socket_channel` imports.
enum FeedConnectionState { connecting, live, reconnecting, offline }
