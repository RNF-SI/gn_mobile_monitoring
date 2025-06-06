// Configuration file for app-wide settings
//
// This file provides a central location for configuration values,
// especially the API URL which is set by the user in the login page.

// Main configuration facade
class Config {
  // Default base URL to use if no custom URL is provided (without /api)
  static const String defaultApiUrl = "https://demo-monitoring.fr";
  
  // Stored URL from localStorage
  static String? _storedApiUrl;

  // Set the URL from localStorage
  static void setStoredApiUrl(String? apiUrl) {
    _storedApiUrl = apiUrl;
  }

  // Clear the stored URL
  static void clearStoredApiUrl() {
    _storedApiUrl = null;
  }

  // Get the API base URL
  static String get apiBase {
    // If a URL is stored in localStorage, use it
    if (_storedApiUrl != null && _storedApiUrl!.isNotEmpty) {
      return _storedApiUrl!;
    }

    // If no URL is stored, return the default URL
    return defaultApiUrl;
  }
}
