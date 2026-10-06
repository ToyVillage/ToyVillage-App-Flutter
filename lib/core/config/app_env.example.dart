enum AppFlavor { stag, prod }

const String _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'stag');
const AppFlavor appFlavor = _flavor == 'prod'
    ? AppFlavor.prod
    : AppFlavor.stag;

class AppEnv {
  final String baseUrl;
  final String sentryDsn;

  const AppEnv({
    required this.baseUrl,
    this.sentryDsn = '',
  });

  static const AppEnv _stag = AppEnv(
    baseUrl: 'https://stag-api.example.com',
    sentryDsn: '',
  );

  static const AppEnv _prod = AppEnv(
    baseUrl: 'https://api.example.com',
    sentryDsn: '',
  );

  static AppEnv get current => switch (appFlavor) {
    AppFlavor.stag => _stag,
    AppFlavor.prod => _prod,
  };
}
