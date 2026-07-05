import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/usecase/use_case.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/domain/repositories/publish_repository.dart';

class PublishMessageParams {
  const PublishMessageParams({required this.serverId, required this.draft});

  final String serverId;
  final PublishDraft draft;
}

/// Publishes a draft to `serverId` (D20: basic publish, text + Markdown,
/// pulled forward with the full advanced-sheet fields per this pass's
/// scope decision).
@injectable
class PublishMessage implements UseCase<PublishMessageParams, void> {
  PublishMessage(this._repository);

  final PublishRepository _repository;

  @override
  Future<Result<void>> call(PublishMessageParams params) =>
      _repository.publish(params.serverId, params.draft);
}
