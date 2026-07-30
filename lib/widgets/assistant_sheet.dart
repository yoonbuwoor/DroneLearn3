import 'package:flutter/material.dart';

import '../core/theme.dart';

void showDroneAtlasAssistant(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FractionallySizedBox(
      heightFactor: .92,
      child: DroneAtlasAssistantSheet(),
    ),
  );
}

class DroneAtlasAssistantSheet extends StatefulWidget {
  const DroneAtlasAssistantSheet({super.key});

  @override
  State<DroneAtlasAssistantSheet> createState() => _DroneAtlasAssistantSheetState();
}

class _DroneAtlasAssistantSheetState extends State<DroneAtlasAssistantSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      fromUser: false,
      text: 'Bonjour ! Je suis DroneAtlas, ton assistant pédagogique. Pose-moi une question sur le drone, la planification, la photogrammétrie, le SIG ou la rédaction du rapport.',
    ),
  ];

  static const _suggestions = [
    'À quoi sert le recouvrement ?',
    'Comment choisir l’altitude ?',
    'DSM ou DTM ?',
    'Structure d’un rapport',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(fromUser: true, text: text));
      _messages.add(_ChatMessage(fromUser: false, text: _answer(text)));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _answer(String input) {
    final value = input.toLowerCase();
    if (value.contains('recouvrement')) {
      return 'Le recouvrement est la partie du terrain visible dans plusieurs photos. Le longitudinal relie les images d’une même ligne ; le latéral relie les lignes voisines. Plus la scène est complexe, végétalisée ou accidentée, plus il faut une marge robuste. Dans le simulateur, observe comment une hausse du recouvrement augmente le nombre d’images et la durée.';
    }
    if (value.contains('altitude') || value.contains('gsd')) {
      return 'L’altitude influence directement le GSD : plus le drone monte, plus un pixel représente une grande surface au sol. Tu couvres davantage de terrain, mais tu perds des détails. Commence toujours par le plus petit objet à distinguer, puis choisis un GSD compatible avec ce besoin.';
    }
    if (value.contains('dsm') || value.contains('dtm') || value.contains('mnt')) {
      return 'Le DSM représente la surface visible : sol, bâtiments et végétation. Le DTM/MNT vise le terrain nu après filtrage. Pour calculer la hauteur d’un bâtiment, on peut comparer une surface contenant l’objet à une référence du terrain, tout en vérifiant la qualité du filtrage.';
    }
    if (value.contains('rapport') || value.contains('rédaction') || value.contains('redaction')) {
      return 'Un rapport clair suit ce fil : contexte → objectifs → zone et matériel → planification → acquisition → traitement → contrôle qualité → résultats → limites → recommandations. Chaque carte doit avoir un titre, une légende, une échelle, une source, une date et le système de coordonnées.';
    }
    if (value.contains('flou') || value.contains('vitesse')) {
      return 'Le flou vient souvent d’une vitesse d’obturation trop lente, d’une vitesse de vol élevée ou de vibrations. Une image floue contient moins de détails fiables pour l’appariement. Contrôle les images à 100 % avant de quitter le site.';
    }
    if (value.contains('gcp') || value.contains('point de contrôle')) {
      return 'Les GCP sont des cibles visibles dont les coordonnées sont connues. Répartis-les autour et à l’intérieur de la zone, sur plusieurs altitudes. Garde aussi des points indépendants qui ne servent pas à ajuster le modèle : ils servent à contrôler honnêtement la précision.';
    }
    if (value.contains('drone') && value.contains('choisir')) {
      return 'Un multirotor convient aux petites zones, aux décollages verticaux et aux inspections détaillées. Une aile fixe couvre mieux les grandes surfaces dégagées. Le choix dépend de la surface, du relief, des obstacles, de l’autonomie et du livrable.';
    }
    if (value.contains('orthophoto')) {
      return 'Une orthophoto est une image corrigée de la perspective et du relief afin de pouvoir être utilisée comme une carte. Elle reste limitée par la qualité du modèle 3D, du géoréférencement, des images et du contrôle terrain.';
    }
    if (value.contains('bonjour') || value.contains('salut')) {
      return 'Bonjour 👋 Choisis un sujet : bases du drone, photo aérienne, planification, traitement, qualité, SIG ou rapport. Je peux aussi te proposer une question de révision.';
    }
    return 'Je peux t’aider sur les bases du drone, la photographie aérienne, le GSD, les recouvrements, les GCP, le plan de vol, le contrôle d’images, le pipeline photogrammétrique, les produits SIG et la rédaction. Reformule ta question avec l’un de ces concepts pour une réponse plus ciblée.';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 46,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.15),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 8, 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset('assets/images/logo.webp'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assistant DroneAtlas', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: success),
                            SizedBox(width: 6),
                            Text('Guide pédagogique hors ligne', style: TextStyle(fontSize: 12, color: success, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
              ),
            ),
            SizedBox(
              height: 45,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ActionChip(
                  avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: Text(_suggestions[index]),
                  onPressed: () => _send(_suggestions[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Pose une question à DroneAtlas…',
                        prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: () => _send(),
                    icon: const Icon(Icons.send_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: cyan,
                      foregroundColor: navy,
                      minimumSize: const Size(52, 52),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: message.fromUser
              ? cyan
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.fromUser ? 18 : 4),
            bottomRight: Radius.circular(message.fromUser ? 4 : 18),
          ),
          border: message.fromUser
              ? null
              : Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.fromUser ? navy : null,
            height: 1.45,
            fontWeight: message.fromUser ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
