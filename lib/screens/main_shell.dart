import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/assistant_sheet.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'missions_screen.dart';
import 'profile_screen.dart';
import 'simulator_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
        onOpenAcademy: () => _goTo(1),
        onOpenSimulator: () => _goTo(2),
        onOpenMissions: () => _goTo(3),
      ),
      LearnScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
      SimulatorScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
      MissionsScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
      ProfileScreen(
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
    ];

    final destinations = const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Accueil'),
      NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school_rounded), label: 'Académie'),
      NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune_rounded), label: 'Simuler'),
      NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag_rounded), label: 'Missions'),
      NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profil'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 960;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: _goTo,
                    labelType: NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 22),
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset('assets/images/logo.webp'),
                      ),
                    ),
                    destinations: destinations
                        .map(
                          (item) => NavigationRailDestination(
                            icon: item.icon,
                            selectedIcon: item.selectedIcon,
                            label: Text(item.label),
                          ),
                        )
                        .toList(),
                  ),
                Expanded(
                  child: IndexedStack(index: _index, children: pages),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'assistant',
            onPressed: () => showDroneAtlasAssistant(context),
            backgroundColor: cyan,
            foregroundColor: navy,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('DroneAtlas', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: _goTo,
                  destinations: destinations,
                ),
        );
      },
    );
  }
}
