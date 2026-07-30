import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../core/theme.dart';
import '../data/academy_data.dart';
import '../models/academy_models.dart';
import '../models/remote_content_models.dart';
import '../widgets/common.dart';
import 'course_detail_screen.dart';
import 'glossary_screen.dart';
import 'quiz_screen.dart';
import 'remote_course_detail_screen.dart';
import 'update_center_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final filtered = modules.where((module) {
      final q = _query.toLowerCase();
      if (q.isEmpty) return true;
      return module.title.toLowerCase().contains(q) ||
          module.subtitle.toLowerCase().contains(q) ||
          module.lessons.any((lesson) => lesson.title.toLowerCase().contains(q));
    }).toList();
    final remoteFiltered = controller.remoteCourses.where((course) {
      final q = _query.toLowerCase();
      if (q.isEmpty) return true;
      return course.title.toLowerCase().contains(q) ||
          course.summary.toLowerCase().contains(q) ||
          course.category.toLowerCase().contains(q);
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: BrandBar(
              isDark: widget.isDark,
              onToggleTheme: widget.onToggleTheme,
              title: 'Académie',
              subtitle: 'Ton parcours complet en photogrammétrie',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
              child: _AcademyHeader(controller: controller),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Rechercher une notion ou une leçon…',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _search.clear();
                                  setState(() => _query = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Glossaire',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlossaryScreen())),
                    icon: const Icon(Icons.menu_book_rounded),
                    style: IconButton.styleFrom(minimumSize: const Size(54, 54)),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Quiz global',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                    icon: const Icon(Icons.quiz_rounded),
                    style: IconButton.styleFrom(minimumSize: const Size(54, 54)),
                  ),
                  const SizedBox(width: 8),
                  Badge(
                    isLabelVisible: controller.updateAvailable,
                    label: const Text('!'),
                    child: IconButton.filledTonal(
                      tooltip: 'Mises à jour',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateCenterScreen())),
                      icon: Icon(controller.updateAvailable ? Icons.new_releases_rounded : Icons.cloud_sync_rounded),
                      style: IconButton.styleFrom(minimumSize: const Size(54, 54)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (remoteFiltered.isNotEmpty)
          SliverToBoxAdapter(
            child: MaxWidthBox(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: const SectionHeading(
                  title: 'Nouveautés téléchargées',
                  subtitle: 'Cours ajoutés après l’installation de l’application.',
                ),
              ),
            ),
          ),
        if (remoteFiltered.isNotEmpty)
          SliverToBoxAdapter(
            child: MaxWidthBox(
              child: SizedBox(
                height: 194,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: remoteFiltered.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => _RemoteCourseCard(
                    course: remoteFiltered[index],
                    completed: controller.lessonCompleted('remote_${remoteFiltered[index].id}'),
                  ),
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: MaxWidthBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: SectionHeading(
                title: _query.isEmpty ? 'Parcours en 8 étapes' : '${filtered.length + remoteFiltered.length} résultat(s)',
                subtitle: _query.isEmpty
                    ? 'Chaque module associe théorie, démonstration et vérification.'
                    : 'Les modules correspondant à ta recherche.',
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverToBoxAdapter(
            child: MaxWidthBox(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1000
                      ? 3
                      : constraints.maxWidth >= 650
                          ? 2
                          : 1;
                  return GridView.builder(
                    itemCount: filtered.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: columns == 1 ? 1.38 : 1.13,
                    ),
                    itemBuilder: (context, index) => _ModuleCard(
                      module: filtered[index],
                      controller: controller,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AcademyHeader extends StatelessWidget {
  const _AcademyHeader({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final total = totalLessonCount + controller.remoteCourses.length;
    final progress = controller.courseProgress(total);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [violet.withOpacity(.24), cyan.withOpacity(.08)],
        ),
        border: Border.all(color: violet.withOpacity(.22)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 620;
          final info = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Pill(label: 'PARCOURS DRONEATLAS', icon: Icons.route_rounded, color: violet),
              const SizedBox(height: 14),
              const Text('De novice à opérateur autonome', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -.7)),
              const SizedBox(height: 7),
              Text(
                '${totalLessonCount + controller.remoteCourses.length} leçons courtes pour comprendre le matériel, préparer une mission, contrôler les produits et rédiger une restitution professionnelle.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
              ),
            ],
          );
          final progressCard = Container(
            width: wide ? 210 : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color?.withOpacity(.62),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: wide ? MainAxisSize.min : MainAxisSize.max,
              children: [
                ProgressRing(value: progress, label: '${(progress * 100).round()} %', color: violet),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${controller.completedLessons.length} leçons', style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text('sur $total validées', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          );
          if (wide) {
            return Row(children: [Expanded(child: info), const SizedBox(width: 20), progressCard]);
          }
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [info, const SizedBox(height: 18), progressCard]);
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.controller});

  final AcademyModule module;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final done = module.lessons.where((lesson) => controller.lessonCompleted(lesson.id)).length;
    final progress = done / module.lessons.length;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openLesson(context, module, module.lessons.first),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GradientIcon(icon: module.icon, color: module.accent, size: 50),
                  const Spacer(),
                  Text(module.number, style: TextStyle(color: module.accent, fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 16),
              Text(module.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(module.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35, fontSize: 13)),
              const Spacer(),
              ...module.lessons.take(2).map(
                    (lesson) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(controller.lessonCompleted(lesson.id) ? Icons.check_circle_rounded : Icons.play_circle_outline_rounded, size: 17, color: controller.lessonCompleted(lesson.id) ? success : module.accent),
                          const SizedBox(width: 7),
                          Expanded(child: Text(lesson.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(99),
                      backgroundColor: module.accent.withOpacity(.12),
                      valueColor: AlwaysStoppedAnimation(module.accent),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('$done/${module.lessons.length}', style: TextStyle(color: module.accent, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLesson(BuildContext context, AcademyModule module, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(module: module, initialLesson: lesson),
      ),
    );
  }
}


class _RemoteCourseCard extends StatelessWidget {
  const _RemoteCourseCard({required this.course, required this.completed});

  final RemoteCourse course;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RemoteCourseDetailScreen(course: course),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GradientIcon(
                      icon: completed ? Icons.verified_rounded : Icons.cloud_done_rounded,
                      color: completed ? success : violet,
                      size: 48,
                    ),
                    const Spacer(),
                    Pill(
                      label: course.duration,
                      icon: Icons.schedule_rounded,
                      color: violet,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  course.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  completed ? 'Cours validé' : '${course.category} • ${course.level}',
                  style: TextStyle(
                    color: completed ? success : violet,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
