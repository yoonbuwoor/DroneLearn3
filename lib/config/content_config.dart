class ContentConfig {
  const ContentConfig._();

  /// Plusieurs sources statiques sont prévues pour éviter une dépendance à
  /// un serveur applicatif. GitHub Pages est prioritaire, puis les branches
  /// publiques main/master du dépôt.
  static const List<String> manifestUrls = <String>[
    'https://yoonbuwoor.github.io/LearnAtlasDrone/content/manifest.json',
    'https://raw.githubusercontent.com/yoonbuwoor/LearnAtlasDrone/main/content/manifest.json',
    'https://raw.githubusercontent.com/yoonbuwoor/LearnAtlasDrone/master/content/manifest.json',
  ];

  static const Duration requestTimeout = Duration(seconds: 18);
  static const Duration backgroundCheckFrequency = Duration(hours: 6);
  static const String backgroundTaskName = 'droneatlas-content-check';
  static const String backgroundTaskId = 'droneatlas-periodic-content-check';
}
