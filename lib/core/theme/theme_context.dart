import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

extension TlThemeContext on BuildContext {
  TlColors get colors => Theme.of(this).extension<TlColors>()!;
  TlText get text => Theme.of(this).extension<TlText>()!;
}
