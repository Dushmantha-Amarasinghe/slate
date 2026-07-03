/// Whether the app should land on the onboarding flow instead of Today.
/// Set synchronously in main.dart before `runApp`, from the async
/// [OnboardingPrefs.hasCompleted] check, so [AppRouter]'s `initialLocation`
/// (resolved on first access, right after runApp) already has the answer —
/// no redirect flicker between Today and Onboarding on cold start.
class OnboardingGate {
  const OnboardingGate._();

  static bool needsOnboarding = false;
}
