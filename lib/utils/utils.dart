import 'dart:io';
import 'dart:math';

import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/theme/text_theme.dart';
import 'package:logger/logger.dart';

import 'src/validators.dart';

part 'src/context_extensions.dart';
part 'src/bloc_observer.dart';
part 'src/base_form_helper.dart';
part 'src/i_password_confirmation_form_helper.dart';

/// A logger with simple output printer
final sLogger = Logger(printer: SimplePrinter());

/// A logger with pretty output printer
final pLogger = Logger(printer: PrettyPrinter());
