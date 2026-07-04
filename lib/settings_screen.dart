import 'package:flutter/material.dart';
import 'main.dart';

const appVersion = '1.0.0';
const lastUpdated = 'June 29, 2026';

class SettingsScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kCream,
        foregroundColor: kLeafDark,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: kMint,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: kLeaf.withOpacity(.25)),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 78,
                  height: 78,
                  errorBuilder: (_, __, ___) =>
                  const Text('🌱', style: TextStyle(fontSize: 62)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Growlio\nGrow better habits daily.',
                    style: TextStyle(
                      color: kLeafDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            value: darkMode,
            activeThumbColor: kLeaf,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_rounded, color: kLeaf),
            onChanged: onDarkModeChanged,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_rounded, color: kLeaf),
            title: Text('App Version'),
            subtitle: Text(appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded, color: kLeaf),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Privacy Policy',
                  sections: privacySections,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article_rounded, color: kLeaf),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Terms & Conditions',
                  sections: termsSections,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalScreen extends StatelessWidget {
  final String title;
  final List<LegalSection> sections;

  const LegalScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kCream,
        foregroundColor: kLeafDark,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Growlio $title',
            style: const TextStyle(
              color: kLeafDark,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Last Updated: $lastUpdated'),
          const SizedBox(height: 18),
          ...sections.map(
                (section) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kLeaf.withOpacity(.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: kLeaf,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(section.body, style: const TextStyle(height: 1.55)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalSection {
  final String title;
  final String body;

  const LegalSection(this.title, this.body);
}

const privacySections = [
  LegalSection(
    '1. Introduction',
    'Growlio is a simple habit garden app designed to help users build habits through a visual plant-growth experience. This Privacy Policy explains how information is handled when using Growlio.',
  ),
  LegalSection(
    '2. Purpose of the App',
    'Growlio allows users to create habits, mark habits as completed, track streaks, grow plant stages, save favorite habits, and manage personal habit notes locally on their device.',
  ),
  LegalSection(
    '3. Information Stored in the App',
    'Growlio stores only the information you choose to enter, including habit names, optional notes, favorite status, streak count, plant level, completion date, and app settings such as dark mode.',
  ),
  LegalSection(
    '4. Local Device Storage',
    'All Growlio data is stored locally on your device using local storage. Growlio does not upload, sync, or transfer your habits or progress information to any server controlled by Growlio.',
  ),
  LegalSection(
    '5. No Account Required',
    'Growlio does not require user registration, login credentials, usernames, passwords, email addresses, phone numbers, profile accounts, or identity verification.',
  ),
  LegalSection(
    '6. No Personal Data Collection',
    'Growlio does not intentionally collect personal information such as your real name, address, location, contacts, photos, camera data, microphone data, payment information, government identifiers, or device identifiers.',
  ),
  LegalSection(
    '7. User-Entered Content',
    'You control what you type into habit names and notes. If you choose to enter personal information, that content remains stored locally on your device and is not transmitted to Growlio-controlled services.',
  ),
  LegalSection(
    '8. Habit Progress Data',
    'Habit progress data may include streak count, plant level, and completion status. This information is used only to display habit progress and plant growth inside the app.',
  ),
  LegalSection(
    '9. No Cloud Synchronization',
    'Growlio does not provide cloud synchronization, online backup, account recovery, or remote data restoration. If local app data is deleted, Growlio cannot recover it from a server.',
  ),
  LegalSection(
    '10. Offline Usage',
    'Growlio is designed to work offline. Core functionality such as creating habits, marking completion, viewing streaks, and managing plants does not require an internet connection.',
  ),
  LegalSection(
    '11. No Analytics',
    'Growlio does not use analytics SDKs or behavioral tracking tools. The app does not track screen views, button taps, habit usage, completion behavior, or how often you use the app.',
  ),
  LegalSection(
    '12. No Advertising',
    'Growlio does not display advertisements and does not include advertising network SDKs, advertising identifiers, personalized ad systems, or marketing trackers.',
  ),
  LegalSection(
    '13. No Third-Party Sharing',
    'Growlio does not sell, rent, trade, disclose, or share your habit information with third parties. Since the app does not use backend services, your data is not transmitted to Growlio-controlled online systems.',
  ),
  LegalSection(
    '14. Platform Services',
    'Platform providers such as Google Play may process app download, crash, or device-level information according to their own policies. That platform-level information is not controlled by Growlio inside the app.',
  ),
  LegalSection(
    '15. Permissions',
    'Growlio is designed to work without sensitive permissions. It does not require access to your camera, microphone, contacts, location, calendar, SMS, phone calls, or external files for its core functionality.',
  ),
  LegalSection(
    '16. Data Security',
    'Keeping data local reduces privacy risk. Your data is protected by your device security settings, such as screen lock, operating system protections, and device encryption where available.',
  ),
  LegalSection(
    '17. User Control',
    'You can create, edit, favorite, complete, undo, and delete habits at any time inside the app. You can also change dark mode from the settings screen.',
  ),
  LegalSection(
    '18. Data Deletion',
    'You can delete individual habits inside the app. You can remove all locally stored Growlio data by clearing app data in your device settings or uninstalling Growlio.',
  ),
  LegalSection(
    '19. Data Retention',
    'Your habit data remains stored locally until you delete it, clear app data, uninstall the app, or reset your device.',
  ),
  LegalSection(
    '20. Children’s Privacy',
    'Growlio is a general habit organization app and is not specifically directed to children. The app does not knowingly collect children’s personal information.',
  ),
  LegalSection(
    '21. Health and Wellness Disclaimer',
    'Growlio is a habit organization tool only. It does not provide medical, psychological, nutritional, fitness, mental health, or professional wellness advice.',
  ),
  LegalSection(
    '22. Changes to This Privacy Policy',
    'This Privacy Policy may be updated from time to time to reflect app improvements, legal requirements, or store policy updates. Any updated version should accurately describe Growlio’s data practices.',
  ),
  LegalSection(
    '23. Acceptance',
    'By continuing to use Growlio, you acknowledge that you have read and understood this Privacy Policy.',
  ),
  LegalSection(
    '24. Contact Information',
    'If you have any questions, concerns, or requests regarding this Privacy Policy, Growlio, or the way your information is handled, you can contact the developer directly.\n\nEmail: d75360693@gmail.com\n\nWe value your privacy and will make every reasonable effort to respond to your inquiry as soon as possible.',
  ),
];

const termsSections = [
  LegalSection(
    '1. Acceptance of Terms',
    'By downloading, opening, or using Growlio, you agree to these Terms & Conditions. If you do not agree, do not use the app.',
  ),
  LegalSection(
    '2. Description of the App',
    'Growlio helps users create simple habits, track daily completion, grow visual plant stages, and organize personal habit progress locally on their device.',
  ),
  LegalSection(
    '3. User Responsibility',
    'You are responsible for the habit names, notes, goals, and progress information you enter into the app.',
  ),
  LegalSection(
    '4. Habit Tool Only',
    'Growlio is a simple organization and motivation tool. It does not guarantee habit success, lifestyle improvement, productivity results, health benefits, or personal outcomes.',
  ),
  LegalSection(
    '5. No Professional Advice',
    'Growlio does not provide medical, psychological, fitness, nutritional, financial, legal, or professional wellness advice.',
  ),
  LegalSection(
    '6. Local Data Only',
    'Growlio stores data locally and does not provide online backup, account recovery, or cloud synchronization.',
  ),
  LegalSection(
    '7. Accuracy Disclaimer',
    'Growlio displays habit progress based on your input. The app cannot verify whether a habit was actually completed or whether progress information is accurate.',
  ),
  LegalSection(
    '8. Acceptable Use',
    'Use Growlio for lawful personal habit organization only. Do not misuse, copy, resell, reverse engineer, or interfere with the app.',
  ),
  LegalSection(
    '9. Intellectual Property',
    'Growlio, including its name, interface, design, branding, and related materials, belongs to its developer or rights holder unless otherwise stated.',
  ),
  LegalSection(
    '10. User Content',
    'You remain responsible for any habit names, notes, or labels you enter. Do not enter content that infringes rights, impersonates others, or violates applicable laws.',
  ),
  LegalSection(
    '11. Limitation of Liability',
    'Growlio is provided as-is. The developer is not responsible for lost local data, missed habits, incorrect streaks, personal outcomes, device issues, or indirect losses.',
  ),
  LegalSection(
    '12. App Availability',
    'Growlio may be updated, changed, interrupted, or removed from distribution over time. Availability may depend on device compatibility and operating system support.',
  ),
  LegalSection(
    '13. Updates',
    'Future updates may improve features, design, compatibility, legal content, or app performance. Continued use means you accept updated terms.',
  ),
  LegalSection(
    '14. Termination',
    'You may stop using Growlio at any time by deleting the app. There is no user account to close.',
  ),
  LegalSection(
    '15. Governing Terms',
    'If any part of these terms is found unenforceable, the remaining sections should continue to apply as allowed by law.',
  ),
  LegalSection(
    '16. Contact',
    'If you have any questions about these Terms & Conditions, the Growlio application, or your use of the app, you can contact the developer at:\n\nEmail: d75360693@gmail.com\n\nWe will do our best to respond to your inquiry as soon as reasonably possible.',
  ),
];