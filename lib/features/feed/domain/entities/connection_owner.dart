/// Who is asking for a topic's WS session to stay open. A session is only
/// torn down once every owner that asked for it has released it — this lets
/// a screen-scoped session (Topic Detail open) and a background-owned
/// session (BackgroundDeliveryService, Task 8) share the same connection
/// instead of opening two sockets to the same topic.
enum ConnectionOwner { screen, background }
