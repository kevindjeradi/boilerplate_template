import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/shared/permissions/interfaces/i_permission_service.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/shared/providers/shared_providers.dart';
import 'package:boilerplate_template/shared/exceptions/permission_exceptions.dart';

part 'permission_controller.g.dart';

// États de permission simplifiés avec enum
enum PermissionStatus {
  initial,
  requesting,
  granted,
  denied,
  permanentlyDenied,
}

// Controller moderne avec Riverpod 3.0 - État simple
@riverpod
class PermissionController extends _$PermissionController {
  late final IPermissionService _permissionService;

  @override
  PermissionStatus build() {
    AppLogger.info('Initializing PermissionController');

    _permissionService = ref.read(permissionServiceProvider);

    return PermissionStatus.initial;
  }

  // Méthodes simplifiées avec try/catch
  Future<bool> handlePermission(PermissionType permissionType) async {
    if (!_canPerformOperation()) return false;

    state = PermissionStatus.requesting;

    try {
      final isGranted =
          await _permissionService.requestPermission(permissionType);

      if (_canPerformOperation()) {
        if (isGranted) {
          state = PermissionStatus.granted;
          return true;
        } else {
          // Vérifier si c'est définitivement refusé
          final isPermanentlyDenied = await _permissionService
              .isPermissionPermanentlyDenied(permissionType);

          state = isPermanentlyDenied
              ? PermissionStatus.permanentlyDenied
              : PermissionStatus.denied;
          return false;
        }
      }
      return false;
    } catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Error requesting permission: $e');
        state = PermissionStatus.denied;
        throw PermissionException('Failed to request permission: $e');
      }
      return false;
    }
  }

  Future<bool> checkPermission(PermissionType permissionType) async {
    try {
      return await _permissionService.isPermissionGranted(permissionType);
    } catch (e) {
      AppLogger.error('Error checking permission: $e');
      throw PermissionException('Failed to check permission: $e');
    }
  }

  void resetState() {
    state = PermissionStatus.initial;
  }

  // Guard pour vérifier si on peut encore effectuer des opérations
  bool _canPerformOperation() {
    return ref.exists(permissionControllerProvider);
  }
}

// Helper providers simplifiés
@riverpod
bool isRequestingPermission(Ref ref) {
  final state = ref.watch(permissionControllerProvider);
  return state == PermissionStatus.requesting;
}

@riverpod
bool isPermissionGranted(Ref ref) {
  final state = ref.watch(permissionControllerProvider);
  return state == PermissionStatus.granted;
}

@riverpod
bool isPermissionDenied(Ref ref) {
  final state = ref.watch(permissionControllerProvider);
  return state == PermissionStatus.denied ||
      state == PermissionStatus.permanentlyDenied;
}
