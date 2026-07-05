import 'package:freezed_annotation/freezed_annotation.dart';

part 'ntfy_action.freezed.dart';

@freezed
sealed class NtfyAction with _$NtfyAction {
  const factory NtfyAction.view({
    required String label,
    required String url,
    @Default(false) bool clear,
  }) = ViewAction;

  const factory NtfyAction.http({
    required String label,
    required String url,
    @Default('POST') String method,
    @Default({}) Map<String, String> headers,
    String? body,
    @Default(false) bool clear,
  }) = HttpAction;

  const factory NtfyAction.broadcast({
    required String label,
    @Default('io.heckel.ntfy.USER_ACTION') String intent,
    @Default({}) Map<String, String> extras,
    @Default(false) bool clear,
  }) = BroadcastAction;

  const factory NtfyAction.copy({
    required String label,
    required String value,
    @Default(false) bool clear,
  }) = CopyAction;
}
