import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

part 'publish_draft.freezed.dart';

@freezed
abstract class PublishDraft with _$PublishDraft {
  const factory PublishDraft({
    required String topic,
    required String body,
    String? title,
    @Default(3) int priority,
    @Default([]) List<String> tags,
    String? attachmentPath,
    @Default(false) bool markdown,
    String? delay,
  }) = _PublishDraft;

  const PublishDraft._();

  /// Validates a candidate [PublishDraft]. [body] may be empty **only**
  /// when [attachmentPath] is set (the file becomes the body; [body], if
  /// given, becomes the `X-Message` caption instead — api_spec.md §2.2).
  static Result<PublishDraft> validate({
    required String topic,
    required String body,
    String? title,
    int priority = 3,
    List<String> tags = const [],
    String? attachmentPath,
    bool markdown = false,
    String? delay,
  }) {
    if (topic.trim().isEmpty) {
      return const Result.err(
        Failure.validation(field: 'topic', message: 'topic must not be empty'),
      );
    }

    if (body.trim().isEmpty && attachmentPath == null) {
      return const Result.err(
        Failure.validation(
          field: 'body',
          message: 'body must not be empty unless an attachment is set',
        ),
      );
    }

    if (priority < 1 || priority > 5) {
      return const Result.err(
        Failure.validation(
          field: 'priority',
          message: 'priority must be between 1 and 5',
        ),
      );
    }

    return Result.success(
      PublishDraft(
        topic: topic,
        body: body,
        title: title,
        priority: priority,
        tags: tags,
        attachmentPath: attachmentPath,
        markdown: markdown,
        delay: delay,
      ),
    );
  }
}
