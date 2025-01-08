abstract class DownloadModuleDataUseCase {
  Future<void> execute(
    int moduleId,
    Function(double) onProgressUpdate,
  );
}
