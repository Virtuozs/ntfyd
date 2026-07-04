import 'package:freezed_annotation/freezed_annotation.dart';

part 'ws_state.freezed.dart';

@freezed
sealed class WsState with _$WsState {
  const factory WsState.connecting() = WsConnecting;
  const factory WsState.connected() = WsConnected;
  const factory WsState.reconnecting({required int attempt}) = WsReconnecting;
  const factory WsState.disconnected({String? reason}) = WsDisconnected;
}
