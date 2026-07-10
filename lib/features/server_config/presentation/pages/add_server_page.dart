import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntfyd/features/server_config/domain/entities/server_config.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_cubit.dart';
import 'package:ntfyd/features/server_config/presentation/cubits/server_add_edit_state.dart';
import 'package:ntfyd/features/server_config/presentation/failure_message.dart';

/// Pushed from [ServerManagerPage] to add a new server, or (with
/// [existing] set) to overwrite an existing server's credentials.
///
/// The caller is expected to supply a [ServerAddEditCubit] via
/// [BlocProvider] (e.g. from GetIt) further up the tree.
class AddServerPage extends StatefulWidget {
  const AddServerPage({super.key, this.existing});

  final ServerConfig? existing;

  @override
  State<AddServerPage> createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isEdit => widget.existing != null;

  // In edit mode, the username/password fields always open blank (you
  // re-enter secrets, you don't view them). If the user taps Save without
  // typing into either field, credentialFromFields('', '') would produce
  // ServerCredential.noAuth(), silently downgrading a basic/bearer server
  // to no-auth even though its authType is untouched. Add mode has no such
  // footgun -- a blank add is a legitimate anonymous-server add -- so only
  // edit mode requires one of the two fields to be non-empty.
  bool get _canSubmit =>
      !_isEdit ||
      _userController.text.trim().isNotEmpty ||
      _passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _userController.addListener(_onCredentialFieldChanged);
    _passwordController.addListener(_onCredentialFieldChanged);
  }

  void _onCredentialFieldChanged() => setState(() {});

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServerAddEditCubit, ServerAddEditState>(
      listener: (context, state) {
        switch (state) {
          case ServerAddEditSuccess():
            Navigator.of(context).pop();
          case ServerAddEditError(failure: final failure):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(friendlyFailureMessage(failure))),
            );
          case ServerAddEditIdle():
          case ServerAddEditValidating():
            break;
        }
      },
      builder: (context, state) {
        final isValidating = state is ServerAddEditValidating;

        return Scaffold(
          appBar: AppBar(
            title: Text(_isEdit ? 'Edit Credentials' : 'Add Server'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isEdit)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        widget.existing!.baseUrl,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  else
                    TextFormField(
                      controller: _urlController,
                      enabled: !isValidating,
                      decoration: const InputDecoration(
                        labelText: 'Server URL (default:https://ntfy.sh)',
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userController,
                    enabled: !isValidating,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !isValidating,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isValidating || !_canSubmit
                        ? null
                        : () => _submit(context),
                    child: isValidating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(_isEdit ? 'Save' : 'Add'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final cubit = context.read<ServerAddEditCubit>();
    if (_isEdit) {
      cubit.editCredentials(
        serverId: widget.existing!.id,
        user: _userController.text,
        password: _passwordController.text,
      );
    } else {
      cubit.addServer(
        url: _urlController.text,
        user: _userController.text,
        password: _passwordController.text,
      );
    }
  }
}
