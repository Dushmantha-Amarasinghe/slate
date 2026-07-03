import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_label.dart';
import '../../onboarding/onboarding_prefs.dart';
import 'widgets/settings_nav_row.dart';

class AboutSettingsScreen extends StatefulWidget {
  const AboutSettingsScreen({super.key});

  @override
  State<AboutSettingsScreen> createState() => _AboutSettingsScreenState();
}

class _AboutSettingsScreenState extends State<AboutSettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo info) {
      if (mounted) setState(() => _packageInfo = info);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String versionLabel = _packageInfo == null
        ? '—'
        : '${_packageInfo!.version} (${_packageInfo!.buildNumber})';

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Slate', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text('by Refora Technologies', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('App'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: <Widget>[
                SettingsNavRow(icon: Icons.tag, title: 'Version', subtitle: versionLabel),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.description_outlined,
                  title: 'Open source licenses',
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Slate',
                    applicationVersion: _packageInfo?.version,
                  ),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.replay_outlined,
                  title: 'Replay onboarding',
                  onTap: () async {
                    await OnboardingPrefs.reset();
                    if (context.mounted) context.go(AppRoutes.onboarding);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Links'),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: <Widget>[
                SettingsNavRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy policy',
                  onTap: () => _openUrl('https://reforatech.github.io/slate/privacy'),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.code_outlined,
                  title: 'Source on GitHub',
                  onTap: () => _openUrl('https://github.com/reforatech/slate'),
                ),
                const SettingsRowDivider(),
                SettingsNavRow(
                  icon: Icons.mail_outline,
                  title: 'Send feedback',
                  onTap: () => _openUrl('mailto:hello@reforatech.dev?subject=Slate%20feedback'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
