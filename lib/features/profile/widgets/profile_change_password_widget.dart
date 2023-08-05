part of '../profile_page.dart';

class _ProfileChangePasswordWidget extends StatefulWidget {
  const _ProfileChangePasswordWidget({
    super.key,
    required ProfileController profileController,
  }) : _profileController = profileController;

  final ProfileController _profileController;

  @override
  State<_ProfileChangePasswordWidget> createState() =>
      _ProfileChangePasswordWidgetState();
}

class _ProfileChangePasswordWidgetState
    extends State<_ProfileChangePasswordWidget> with CustomSnackBar {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(handlePasswordChange);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void handlePasswordChange() {
    if (_formKey.currentState != null && _focusNode.hasFocus) {
      widget._profileController
          .toggleButtonTap(_formKey.currentState?.validate() ?? false);
    }
  }

  Future<void> onNewPasswordSavePressed() async {
    if (_focusNode.hasFocus) _focusNode.unfocus();

    await widget._profileController
        .updateUserPassword(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        Form(
          key: _formKey,
          child: PasswordFormField(
            controller: _textEditingController,
            focusNode: _focusNode,
            labelText: 'New password',
            onTapOutside: (_) => _focusNode.unfocus(),
            validator: (_) =>
                Validator.validatePassword(_textEditingController.text),
            onEditingComplete: widget._profileController.canSave
                ? onNewPasswordSavePressed
                : null,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  widget._profileController.onChangePasswordTapped();
                  widget._profileController.toggleButtonTap(false);
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyles.mediumText16w500
                      .apply(color: AppColors.green),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextButton(
                onPressed: widget._profileController.canSave
                    ? onNewPasswordSavePressed
                    : null,
                child: Text(
                  'Save',
                  style: AppTextStyles.mediumText16w500
                      .apply(color: AppColors.green),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
