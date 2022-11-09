import 'package:flutter/services.dart';

///Classe auxiliar que sobrecarrega a atuação do TextInpuFormatter
///para formatar o texto digitado no campo para maiúsculo
///
///Fonte: https://stackoverflow.com/a/49239762
class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
