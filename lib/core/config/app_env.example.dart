enum AppFlavor { stag, prod }

const AppFlavor appFlavor = AppFlavor.stag;

class AppEnv {
  final String baseUrl;
  final String adminEmail;
  final String adminPassword;

  const AppEnv({
    required this.baseUrl,
    required this.adminEmail,
    required this.adminPassword,
  });

  static const AppEnv _stag = AppEnv(
    baseUrl: 'https://stag-api.example.com',
    adminEmail: 'your-email@example.com',
    adminPassword: 'your-password',
  );

  static const AppEnv _prod = AppEnv(
    baseUrl: 'https://api.example.com',
    adminEmail: '',
    adminPassword: '',
  );

  static AppEnv get current => switch (appFlavor) {
    AppFlavor.stag => _stag,
    AppFlavor.prod => _prod,
  };
}
