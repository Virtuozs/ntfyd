import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_filter.freezed.dart';

@freezed
abstract class MessageFilter with _$MessageFilter {
  const factory MessageFilter({
    @Default({}) Set<int> priorities,
    @Default({}) Set<String> tags,
  }) = _MessageFilter;
}
