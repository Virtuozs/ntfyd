import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/domain/usecases/publish_message.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_state.dart';

@injectable
class PublishCubit extends Cubit<PublishState> {
  PublishCubit(this._publishMessage) : super(const PublishState.idle());

  final PublishMessage _publishMessage;

  Future<void> submit(String serverId, PublishDraft draft) async {
    emit(const PublishState.submitting());

    final result = await _publishMessage.call(
      PublishMessageParams(serverId: serverId, draft: draft),
    );

    if (result.isSuccess) {
      emit(const PublishState.success());
    } else {
      emit(PublishState.error(failure: result.failureOrThrow));
    }
  }

  void reset() => emit(const PublishState.idle());
}
