import '../model/base_visit.dart';
import '../repository/permission_repository.dart';

class CheckPermissionUseCase {
  final PermissionRepository permissionRepository;

  CheckPermissionUseCase({required this.permissionRepository});

  Future<bool> canCreateVisit(String moduleCode) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    return (permission?.visits.create ?? 0) > 0;
  }

  Future<bool> canReadVisit(String moduleCode, BaseVisit visit) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    if (permission == null) return false;

    final scope = permission.visits.read;
    return await _checkVisitPermission(scope, visit);
  }

  Future<bool> canUpdateVisit(String moduleCode, BaseVisit visit) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    if (permission == null) return false;

    final scope = permission.visits.update;
    return await _checkVisitPermission(scope, visit);
  }

  Future<bool> canDeleteVisit(String moduleCode, BaseVisit visit) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    if (permission == null) return false;

    final scope = permission.visits.delete;
    return await _checkVisitPermission(scope, visit);
  }

  Future<bool> canCreateObservation(String moduleCode, BaseVisit visit) async {
    // Les observations héritent des permissions de leur visite parent
    return await canUpdateVisit(moduleCode, visit);
  }

  Future<bool> canReadObservation(String moduleCode, BaseVisit visit) async {
    return await canReadVisit(moduleCode, visit);
  }

  Future<bool> canUpdateObservation(String moduleCode, BaseVisit visit) async {
    return await canUpdateVisit(moduleCode, visit);
  }

  Future<bool> canDeleteObservation(String moduleCode, BaseVisit visit) async {
    return await canDeleteVisit(moduleCode, visit);
  }

  Future<bool> canCreateSite(String moduleCode) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    return (permission?.sites.create ?? 0) > 0;
  }

  Future<bool> canReadSite(String moduleCode) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    return (permission?.sites.read ?? 0) > 0;
  }

  Future<bool> canUpdateSite(String moduleCode) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    return (permission?.sites.update ?? 0) > 0;
  }

  Future<bool> canDeleteSite(String moduleCode) async {
    final permission = await permissionRepository.getPermission(moduleCode);
    return (permission?.sites.delete ?? 0) > 0;
  }

  Future<bool> _checkVisitPermission(int scope, BaseVisit visit) async {
    if (scope == 0) return false;  // Aucun accès
    if (scope == 3) return true;   // Toutes les données

    final currentUser = await permissionRepository.getCurrentUser();
    if (currentUser == null) return false;

    // Scope 1: utilisateur digitaliseur ou observateur
    if (scope >= 1) {
      // Vérifier si l'utilisateur est le digitaliseur
      if (visit.idDigitiser == currentUser.id) {
        return true;
      }

      // Vérifier si l'utilisateur est un observateur
      if (visit.observers?.contains(currentUser.id) == true) {
        return true;
      }
    }

    // Scope 2: même organisme
    if (scope >= 2 && currentUser.organismeId != null) {
      // Note: Pour une vérification complète de l'organisme, il faudrait
      // récupérer les informations d'organisme du digitaliseur et des observateurs
      // de la visite depuis la base de données. Pour l'instant, nous pouvons
      // seulement vérifier si l'utilisateur courant appartient à un organisme.
      // Cette logique devra être étendue selon les besoins.
      
      // TODO: Implémenter la vérification d'organisme complète
      // Pour l'instant, on retourne false car on ne peut pas vérifier
      // l'organisme du digitaliseur et des observateurs de la visite
      return false;
    }

    return false;
  }
}