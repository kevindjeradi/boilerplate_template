import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/error_handling/services/error_handling_service.dart';

part 'error_providers.g.dart';

// ==================== ERROR HANDLING PROVIDERS ====================

@Riverpod(keepAlive: true)
ErrorHandlingService errorHandlingService(Ref ref) {
  return ErrorHandlingService();
}
