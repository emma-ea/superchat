class Env {
  static const String env = String.fromEnvironment(
    'prod', 
    defaultValue: 'dev'
  );
}