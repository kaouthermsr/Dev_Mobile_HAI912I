import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  // Utilisez l'instance statique correcte
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Méthode de suivi des événements
  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters.cast<String, Object>(),
    );
  }


  // Exemple de suivi d'utilisateur
  Future<void> setUserProperty(String name, String value) async {
    await analytics.setUserProperty(name: name, value: value);
  }
}
