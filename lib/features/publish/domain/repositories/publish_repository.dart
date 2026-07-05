import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';

abstract class PublishRepository {
  Future<Result<void>> publish(String serverId, PublishDraft draft);
}
