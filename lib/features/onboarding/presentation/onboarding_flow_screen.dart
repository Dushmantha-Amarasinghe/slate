import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../../core/notifications/notification_service.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../onboarding_prefs.dart';
import 'widgets/onboarding_page.dart';

enum _StepKind { philosophy, notificationsPrimer, exactAlarmPrimer, batteryPrimer }

class _Step {
  const _Step({
    required this.kind,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryLabel,
  });

  final _StepKind kind;
  final IconData icon;
  final String title;
  final String description;
  final String primaryLabel;
}

const List<_Step> _kSteps = <_Step>[
  _Step(
    kind: _StepKind.philosophy,
    icon: Icons.check_circle_outline,
    title: 'Welcome to Slate',
    description: 'A quiet place to keep track of what matters today — '
        'nothing more, nothing less.',
    primaryLabel: 'Next',
  ),
  _Step(
    kind: _StepKind.philosophy,
    icon: Icons.visibility_outlined,
    title: 'Built to disappear',
    description: 'No color for the sake of color, no clutter competing for '
        'attention. Just your tasks, and a little motion where it counts.',
    primaryLabel: 'Next',
  ),
  _Step(
    kind: _StepKind.philosophy,
    icon: Icons.lock_outline,
    title: 'Everything stays on this device',
    description: 'No account, no server, no analytics. Your tasks never '
        'leave your phone unless you export them yourself.',
    primaryLabel: 'Next',
  ),
  _Step(
    kind: _StepKind.notificationsPrimer,
    icon: Icons.notifications_outlined,
    title: 'Stay on top of due tasks',
    description: 'Slate can remind you when something\'s due. This just '
        'asks Android for permission to show that notification.',
    primaryLabel: 'Enable notifications',
  ),
  _Step(
    kind: _StepKind.exactAlarmPrimer,
    icon: Icons.alarm_outlined,
    title: 'Make reminders exact',
    description: 'Without this, Android may delay reminders by several '
        'minutes to save battery. Slate only asks for this to keep '
        'reminders on time.',
    primaryLabel: 'Enable exact alarms',
  ),
  _Step(
    kind: _StepKind.batteryPrimer,
    icon: Icons.battery_saver_outlined,
    title: 'Keep reminders reliable',
    description: 'Excluding Slate from battery optimization stops some '
        'phones from silently blocking reminders in the background.',
    primaryLabel: 'Get Started',
  ),
];

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> with WidgetsBindingObserver {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final Map<int, bool> _granted = <int, bool>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermissionStatus();
  }

  Future<void> _refreshPermissionStatus() async {
    final bool notifications = await NotificationService.areNotificationsEnabled();
    final bool exactAlarms = await NotificationService.canScheduleExactAlarms();
    final bool battery = await ph.Permission.ignoreBatteryOptimizations.isGranted;
    if (!mounted) return;
    setState(() {
      _granted[3] = notifications;
      _granted[4] = exactAlarms;
      _granted[5] = battery;
    });
  }

  Future<void> _onPrimaryTap(int index) async {
    final _Step step = _kSteps[index];
    switch (step.kind) {
      case _StepKind.notificationsPrimer:
        await NotificationService.requestNotificationPermission();
        await _refreshPermissionStatus();
      case _StepKind.exactAlarmPrimer:
        await NotificationService.requestExactAlarmPermission();
        await _refreshPermissionStatus();
      case _StepKind.batteryPrimer:
        await ph.Permission.ignoreBatteryOptimizations.request();
        await _refreshPermissionStatus();
      case _StepKind.philosophy:
        break;
    }
    if (!mounted) return;
    if (index == _kSteps.length - 1) {
      await _finish();
    } else {
      _goToPage(index + 1);
    }
  }

  void _goToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    await OnboardingPrefs.markCompleted();
    if (!mounted) return;
    context.go(AppRoutes.today);
  }

  String? _statusLabel(int index) {
    if (index < 3) return null;
    final bool? granted = _granted[index];
    if (granted == null) return null;
    return granted ? 'Allowed' : 'Not allowed yet';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md, top: AppSpacing.xs),
                child: _currentPage == _kSteps.length - 1
                    ? const SizedBox(height: 40)
                    : TextButton(onPressed: _finish, child: const Text('Skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _kSteps.length,
                onPageChanged: (int index) => setState(() => _currentPage = index),
                itemBuilder: (BuildContext context, int index) {
                  final _Step step = _kSteps[index];
                  return OnboardingPage(
                    icon: step.icon,
                    title: step.title,
                    description: step.description,
                    statusLabel: _statusLabel(index),
                  );
                },
              ),
            ),
            _PageIndicator(count: _kSteps.length, currentIndex: _currentPage),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _onPrimaryTap(_currentPage),
                  child: Text(_kSteps[_currentPage].primaryLabel),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: scheme.onSurface.withValues(alpha: active ? 0.85 : 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
