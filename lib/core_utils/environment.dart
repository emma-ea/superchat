class Env {
  static const String activeEnvironment = String.fromEnvironment(
    'ENV', 
    defaultValue: 'dev'
  );

  static const bool isDev = activeEnvironment == 'dev';

  static const bool isProd = activeEnvironment == 'prod';
}