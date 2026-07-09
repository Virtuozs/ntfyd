import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_cubit.dart';
import 'package:ntfyd/features/publish/presentation/cubits/publish_state.dart';
import 'package:ntfyd/features/publish/presentation/widgets/advanced_publish_sheet.dart';

/// Publish composer (D20): "Send message…" + Send, with a `^` button that
/// expands [AdvancedPublishSheet]. Reads/writes the `PublishCubit`
/// provided by an ancestor (`HomePage`'s `_openTopicDetail`) — the same
/// convention `TopicDetailPage` already uses for `FeedBloc`.
class ComposerBar extends StatefulWidget {
  const ComposerBar({super.key, required this.serverId, required this.topic});

  final String serverId;
  final String topic;

  @override
  State<ComposerBar> createState() => _ComposerBarState();
}

class _ComposerBarState extends State<ComposerBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final draft = PublishDraft.validate(
      topic: widget.topic,
      body: text,
    ).valueOrThrow;

    context.read<PublishCubit>().submit(widget.serverId, draft);
  }

  Future<void> _openAdvancedSheet() async {
    final cubit = context.read<PublishCubit>();
    final draft = await showModalBottomSheet<PublishDraft>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AdvancedPublishSheet(
        topic: widget.topic,
        initialBody: _textController.text,
      ),
    );
    if (draft != null) {
      unawaited(cubit.submit(widget.serverId, draft));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PublishCubit, PublishState>(
      listener: (context, state) {
        if (state is PublishSuccess) {
          _textController.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Message sent')));
        } else if (state is PublishError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_messageFor(state.failure))));
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Send message…',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.expand_less),
                      tooltip: 'Advanced options',
                      onPressed: _openAdvancedSheet,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BlocBuilder<PublishCubit, PublishState>(
                builder: (context, state) {
                  final isSubmitting = state is PublishSubmitting;
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(64, 48),
                    ),
                    onPressed: isSubmitting ? null : _send,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    NetworkFailure() => 'Network error — check your connection.',
    _ => 'Failed to send message.',
  };
}
