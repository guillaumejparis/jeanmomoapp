import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'open_url_io.dart' if (dart.library.html) 'open_url_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JeanMomo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'JeanMomo',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => openUrl('https://bw.jeanmomo.ovh/'),
                      child: const Text('Bitwarden'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://nextcloud.jeanmomo.ovh/'),
                      child: const Text('Nextcloud'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => openUrl('https://ha.jeanmomo.ovh/'),
                  child: const Text('Home Assistant'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => openUrl('https://radarr.jeanmomo.ovh/'),
                      child: const Text('Radarr'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => openUrl('https://sonarr.jeanmomo.ovh/'),
                      child: const Text('Sonarr'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => openUrl('https://jellyfin.jeanmomo.ovh/'),
                  child: const Text('Jellyfin'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => openUrl('https://sabnzbd.jeanmomo.ovh/'),
                      child: const Text('SABnzbd'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://qbittorrent.jeanmomo.ovh/'),
                      child: const Text('qBittorrent'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => openUrl('https://beszel.jeanmomo.ovh/'),
                      child: const Text('Beszel'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () =>
                          openUrl('https://guillaumejparis.github.io/recipes/'),
                      child: const Text('Basilic'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
