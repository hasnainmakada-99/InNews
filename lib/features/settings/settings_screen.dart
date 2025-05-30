import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              _buildThemeSelector(context, ref, themeState),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'About',
            children: [
              _buildInfoTile(
                context,
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: AppStrings.appVersion,
              ),
              _buildInfoTile(
                context,
                icon: Icons.description_outlined,
                title: AppStrings.about,
                subtitle: AppStrings.appDescription,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeState themeState,
  ) {
    return ListTile(
      leading: Icon(
        Icons.palette_outlined,
        color: AppTheme.primaryColor,
      ),
      title: const Text(AppStrings.theme),
      subtitle: Text(_getThemeModeText(themeState.themeMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeDialog(context, ref, themeState),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppStrings.lightMode;
      case ThemeMode.dark:
        return AppStrings.darkMode;
      case ThemeMode.system:
        return AppStrings.systemMode;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeState themeState,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              ref,
              ThemeMode.system,
              AppStrings.systemMode,
              themeState.themeMode,
            ),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.light,
              AppStrings.lightMode,
              themeState.themeMode,
            ),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.dark,
              AppStrings.darkMode,
              themeState.themeMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    String title,
    ThemeMode currentMode,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: mode,
      groupValue: currentMode,
      onChanged: (value) {
        if (value != null) {
          ref.read(themeProvider.notifier).setThemeMode(value);
          Navigator.of(context).pop();
        }
      },
    );
  }
}