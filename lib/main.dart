import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWordPair = WordPair.random();

  void getNext() {
    currentWordPair = WordPair.random();
    notifyListeners();
  }

  var favoritesList = <WordPair>[];

  void toggleFavorite() {
    if (favoritesList.contains(currentWordPair)) {
      favoritesList.remove(currentWordPair);
    } else {
      favoritesList.add(currentWordPair);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    StatelessWidget currentPage;

    switch (selectedIndex) {
      case 0:
        currentPage = const GeneratorPage();
        break;
      case 1:
        currentPage = const FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 500,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.error),
                      label: Text('Unimplemented'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: currentPage,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.currentWordPair;

    IconData icon;
    if (appState.favoritesList.contains(wordPair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(wordPair: wordPair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override

  Widget build(BuildContext context) {
    return const Center();
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.wordPair,
  });

  final WordPair wordPair;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          wordPair.asLowerCase,
          style: const TextStyle(color: Colors.black, fontSize: 50),
          semanticsLabel: "${wordPair.first} ${wordPair.second}",),
      ),
    );
  }
}
