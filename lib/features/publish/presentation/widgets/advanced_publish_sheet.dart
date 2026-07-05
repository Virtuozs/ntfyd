import 'dart:io' show Platform;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/core/utils/tag_utils.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';

typedef PickFileFn = Future<FilePickerResult?> Function();

Future<FilePickerResult?> _defaultPickFile() => FilePicker.platform.pickFiles();

/// `^` advanced publish sheet (D20/OI2): title, priority (1–5), tags (CSV),
/// attachment (local file picker), Markdown toggle, schedule (`delay`).
/// Returns the built [PublishDraft] via `Navigator.pop` when "Publish" is
/// tapped with a valid draft; the sheet stays open (returns nothing) if
/// validation fails.
class AdvancedPublishSheet extends StatefulWidget {
  const AdvancedPublishSheet({
    super.key,
    required this.topic,
    this.initialBody = '',
    this.pickFile = _defaultPickFile,
  });

  final String topic;
  final String initialBody;
  final PickFileFn pickFile;

  @override
  State<AdvancedPublishSheet> createState() => _AdvancedPublishSheetState();
}

class _AdvancedPublishSheetState extends State<AdvancedPublishSheet> {
  late final _bodyController = TextEditingController(
    text: widget.initialBody,
  );
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final _delayController = TextEditingController();
  int _priority = 3;
  bool _markdown = false;
  String? _attachmentPath;

  @override
  void dispose() {
    _bodyController.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final result = await widget.pickFile();
    final path = result?.files.single.path;
    if (path != null) {
      setState(() => _attachmentPath = path);
    }
  }

  void _publish() {
    final result = PublishDraft.validate(
      topic: widget.topic,
      body: _bodyController.text.trim(),
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      priority: _priority,
      tags: tagsFromCsv(_tagsController.text),
      attachmentPath: _attachmentPath,
      markdown: _markdown,
      delay: _delayController.text.trim().isEmpty
          ? null
          : _delayController.text.trim(),
    );

    if (result.isSuccess) {
      Navigator.of(context).pop(result.valueOrThrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Advanced publish',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(labelText: 'Message'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title (optional)'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _priority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 - Min')),
              DropdownMenuItem(value: 2, child: Text('2 - Low')),
              DropdownMenuItem(value: 3, child: Text('3 - Default')),
              DropdownMenuItem(value: 4, child: Text('4 - High')),
              DropdownMenuItem(value: 5, child: Text('5 - Max')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _priority = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags (comma-separated, optional)',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickAttachment,
            icon: const Icon(Icons.attach_file),
            label: Text(
              _attachmentPath == null
                  ? 'Attach file (optional)'
                  : _attachmentPath!.split(Platform.pathSeparator).last,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Markdown'),
            value: _markdown,
            onChanged: (value) => setState(() => _markdown = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _delayController,
            decoration: const InputDecoration(
              labelText: 'Schedule (e.g. 30m, optional)',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _publish, child: const Text('Publish')),
        ],
      ),
    );
  }
}
