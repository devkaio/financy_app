import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/widgets.dart';
import '../profile.dart';

class ProfileChangeNameWidget extends StatefulWidget {
  const ProfileChangeNameWidget({
    super.key,
    required ProfileController profileController,
  }) : _profileController = profileController;

  final ProfileController _profileController;

  @override
  State<ProfileChangeNameWidget> createState() =>
      _ProfileChangeNameWidgetState();
}

class _ProfileChangeNameWidgetState extends State<ProfileChangeNameWidget>
    with CustomSnackBar {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(handleNameChange);
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  void handleNameChange() {
    if (_formKey.currentState != null && _focusNode.hasFocus) {
      widget._profileController
          .toggleButtonTap(_formKey.currentState?.validate() ?? false);
    }
  }

  Future<void> onNewNameSavePressed() async {
    if (_focusNode.hasFocus) _focusNode.unfocus();

    await widget._profileController.updateUserName(_textEditingController.text);

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        Form(
          key: _formKey,
          child: CustomTextFormField(
            inputFormatters: [UpperCaseTextInputFormatter()],
            controller: _textEditingController,
            focusNode: _focusNode,
            labelText: 'New name',
            onTapOutside: (_) => _focusNode.unfocus(),
            validator: (_) =>
                Validator.validateName(_textEditingController.text),
            onEditingComplete:
                widget._profileController.canSave ? onNewNameSavePressed : null,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  _textEditingController.clear();
                  widget._profileController.onChangeNameTapped();
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
                    ? onNewNameSavePressed
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
