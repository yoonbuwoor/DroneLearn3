import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../core/theme.dart';
import '../data/academy_data.dart';
import '../models/academy_models.dart';
import '../widgets/common.dart';
import 'domain_detail_screen.dart';
import 'mission_player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onOpenAcademy,
    required this.onOpenSimulator,
    required this.onOpenMissions,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenAcademy;
  final VoidCallback onOpenSimulator;
  final VoidCallback onOpenMissions;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final progress = controller.courseProgress(totalLessonCount);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: BrandBar(isDark: isDark, onToggleTheme: onToggleTheme),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 22),
              child: _Hero(
                progress: progress,
                onOpenAcademy: onOpenAcademy,
                onOpenSimulator: onOpenSimulator,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: columns == 4 ? 1.18 : 1.28,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MetricCard(value: '${controller.completedLessons.length}/$totalLessonCount', label: 'Leçons validées', icon: Icons.menu_book_rounded),
                      MetricCard(value: '${controller.xp}', label: 'Points d’expérience', icon: Icons.bolt_rounded, accent: orange),
                      MetricCard(value: '${controller.streak} jours', label: 'Série actuelle', icon: Icons.local_fire_department_rounded, accent: danger),
                      MetricCard(value: '${controller.completedMissions.length}/${missions.length}', label: 'Missions réussies', icon: Icons.verified_rounded, accent: success),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: SectionHeading(
                title: 'Continuer ton parcours',
                subtitle: 'Un guide complet, des bases du drone jusqu’au rapport final.',
                actionLabel: 'Tout voir',
                onAction: onOpenAcademy,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: SizedBox(
              height: 204,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: modules.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  final done = module.lessons.where((lesson) => controller.lessonCompleted(lesson.id)).length;
                  return _ModuleTeaser(
                    module: module,
                    done: done,
                    onTap: onOpenAcademy,
                  );
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: SectionHeading(
                title: 'Mission recommandée',
                subtitle: 'Apprends en prenant des décisions dans un scénario réaliste.',
                actionLabel: 'Toutes les missions',
                onAction: onOpenMissions,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _MissionBanner(mission: missions.first),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: const SectionHeading(
                title: 'Choisis ton domaine',
                subtitle: 'Chaque domaine possède ses objectifs, son plan de vol et ses pièges.',
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: SizedBox(
              height: 232,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: domains.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _DomainCard(domain: domains[index]),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
              child: _OfflineNote(onOpenSimulator: onOpenSimulator),
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.progress, required this.onOpenAcademy, required this.onOpenSimulator});

  final double progress;
  final VoidCallback onOpenAcademy;
  final VoidCallback onOpenSimulator;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 430),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: AssetImage('assets/images/gal6.webp'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: cyan.withOpacity(.09), blurRadius: 30, offset: const Offset(0, 16)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [navy.withOpacity(.2), navy.withOpacity(.97)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 720;
            final content = Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Pill(label: '100 % SIMULATION • AUCUNE IMAGE À IMPORTER', icon: Icons.offline_bolt_rounded),
                const SizedBox(height: 16),
                Text(
                  'Apprends la\nphotogrammétrie\nen pratiquant.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: wide ? 48 : 39,
                    height: .98,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.7,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 610),
                  child: Text(
                    'Du premier contrôle du drone à la rédaction du rapport : cours courts, fragments d’images, missions virtuelles et simulateurs interactifs.',
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.45),
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: onOpenAcademy,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Commencer le parcours'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onOpenSimulator,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                      ),
                      icon: const Icon(Icons.tune_rounded),
                      label: const Text('Ouvrir le simulateur'),
                    ),
                  ],
                ),
              ],
            );
            final progressCard = Container(
              width: wide ? 210 : double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.09),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withOpacity(.12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressRing(value: progress, label: '${(progress * 100).round()} %', size: 92),
                  const SizedBox(height: 14),
                  const Text('PROGRESSION GLOBALE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: .7)),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.route_rounded, color: orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(child: Text('8 modules guidés', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.science_rounded, color: cyan, size: 20),
                      SizedBox(width: 8),
                      Expanded(child: Text('4 laboratoires', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                    ],
                  ),
                ],
              ),
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 3, child: content),
                  const SizedBox(width: 28),
                  progressCard,
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 22),
                progressCard,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModuleTeaser extends StatelessWidget {
  const _ModuleTeaser({required this.module, required this.done, required this.onTap});

  final AcademyModule module;
  final int done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = done / module.lessons.length;
    return SizedBox(
      width: 265,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GradientIcon(icon: module.icon, color: module.accent, size: 46),
                    const Spacer(),
                    Text(module.number, style: TextStyle(color: module.accent, fontSize: 20, fontWeight: FontWeight.w900)),
                  ],
                ),
                const Spacer(),
                Text(module.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('${module.lessons.length} leçons • ${(module.lessons.length * 10)} min', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 13),
                LinearProgressIndicator(value: progress, minHeight: 6, borderRadius: BorderRadius.circular(99), backgroundColor: module.accent.withOpacity(.12), valueColor: AlwaysStoppedAnimation(module.accent)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MissionBanner extends StatelessWidget {
  const _MissionBanner({required this.mission});

  final TrainingMission mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 270),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(mission.image), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [navy.withOpacity(.96), navy.withOpacity(.32)]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Wrap(spacing: 8, children: [Pill(label: mission.level, icon: Icons.signal_cellular_alt_rounded), Pill(label: mission.duration, icon: Icons.timer_outlined, color: orange)]),
            const SizedBox(height: 14),
            Text(mission.title, style: const TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 650), child: Text(mission.brief, style: const TextStyle(color: Colors.white70, height: 1.4))),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MissionPlayerScreen(mission: mission))),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Lancer la mission'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainCard extends StatelessWidget {
  const _DomainCard({required this.domain});

  final ApplicationDomain domain;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DomainDetailScreen(domain: domain))),
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(image: AssetImage(domain.image), fit: BoxFit.cover),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, navy.withOpacity(.95)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: cyan, borderRadius: BorderRadius.circular(12)), child: Icon(domain.icon, color: navy, size: 20)),
                const SizedBox(height: 12),
                Text(domain.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(domain.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote({required this.onOpenSimulator});

  final VoidCallback onOpenSimulator;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 650;
            const text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Un laboratoire qui fonctionne sans drone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                SizedBox(height: 6),
                Text('Les fragments, cartes, défauts et produits sont préchargés. Tu peux apprendre, expérimenter et recommencer sans envoyer de données réelles.'),
              ],
            );
            final button = OutlinedButton.icon(
              onPressed: onOpenSimulator,
              icon: const Icon(Icons.science_rounded),
              label: const Text('Tester maintenant'),
            );
            if (wide) {
              return Row(
                children: [
                  const GradientIcon(icon: Icons.offline_bolt_rounded, color: success, size: 58),
                  const SizedBox(width: 16),
                  Expanded(child: text),
                  const SizedBox(width: 16),
                  button,
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientIcon(icon: Icons.offline_bolt_rounded, color: success, size: 58),
                const SizedBox(height: 14),
                text,
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, child: button),
              ],
            );
          },
        ),
      ),
    );
  }
}
