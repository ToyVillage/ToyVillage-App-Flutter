enum AppFlavor { stag, prod }

const AppFlavor appFlavor = AppFlavor.stag;

class AppEnv {
  final String baseUrl;

  const AppEnv({
    required this.baseUrl,
  });

  static const AppEnv _stag = AppEnv(
    baseUrl: 'https://stag-api.example.com',
  );

  static const AppEnv _prod = AppEnv(
    baseUrl: 'https://api.example.com',
  );

  static AppEnv get current => switch (appFlavor) {
    AppFlavor.stag => _stag,
    AppFlavor.prod => _prod,
  };
}
