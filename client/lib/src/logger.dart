import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(),
);

Logger getLogger() => _logger;
