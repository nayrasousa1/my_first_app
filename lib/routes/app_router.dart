import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/models/candidate.dart';
import 'package:my_first_app/screens/create_candidate_screen.dart';
import 'package:my_first_app/screens/edit_candidate_screen.dart';
import 'package:my_first_app/screens/home_screen.dart';
import 'app_routes.dart';

/// Configuração central de navegação com go_router.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createCandidate,
        builder: (BuildContext context, GoRouterState state) =>
            const CreateCandidateScreen(),
      ),
      GoRoute(
        path: AppRoutes.editCandidate,
        builder: (BuildContext context, GoRouterState state) {
          final candidate = state.extra as Candidate;
          return EditCandidateScreen(candidate: candidate);
        },
      ),
    ],
  );
}
