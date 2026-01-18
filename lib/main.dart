import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'open_url.dart';

void main() {
  runApp(const MyApp());
}

final manager = OidcUserManager.lazy(
  discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
    Uri.parse('https://authentik.jeanmomo.ovh/application/o/jean-momo-oidc'),
  ),
  clientCredentials: OidcClientAuthentication.none(
    clientId: 'x6iTsUUU09S2uNlEzZuuvxB6oa7YPiOxOY3sI30a',
  ),
  store: OidcDefaultStore(),
  settings: OidcUserManagerSettings(
    redirectUri: kIsWeb
        ? Uri.parse('https://jeanmomo.ovh/oicd-callback/')
        : Uri.parse('ovh.jeanmomo.jeanmomo://callback'),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription _userSub;
  bool _loginComplete = false;
  bool _loginSuccess = false;
  String? _loginError;

  @override
  void initState() {
    super.initState();
    _initAndListen();
  }

  Future<void> _initAndListen() async {
    await manager.init();
    _userSub = manager.userChanges().listen((user) {
      setState(() {
        _loginComplete = true;
        _loginSuccess = user != null;
        _loginError = user == null ? 'User not logged in.' : null;
      });
    });
    await _doLogin();
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
  }

  Future<void> _doLogin() async {
    try {
      await manager.loginAuthorizationCodeFlow();
    } catch (e) {
      setState(() {
        _loginComplete = true;
        _loginSuccess = false;
        _loginError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loginComplete) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      );
    }
    if (!_loginSuccess) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Login failed: $_loginError'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loginComplete = false;
                    });
                    _doLogin();
                  },
                  child: const Text('Retry Login'),
                ),
              ],
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }
    return MaterialApp(
      title: 'Jean Momo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          brightness: Brightness.dark,
        ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icon-maskable-192.png',
                    width: 128,
                    height: 128,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://bw.jeanmomo.ovh/', context),
                      child: const Text('Bitwarden'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://nextcloud.jeanmomo.ovh/', context),
                      child: const Text('Nextcloud'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => openUrl('https://ha.jeanmomo.ovh/', context),
                  child: const Text('Home Assistant'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://radarr.jeanmomo.ovh/', context),
                      child: const Text('Radarr'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://sonarr.jeanmomo.ovh/', context),
                      child: const Text('Sonarr'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      openUrl('https://jellyfin.jeanmomo.ovh/', context),
                  child: const Text('Jellyfin'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://sabnzbd.jeanmomo.ovh/', context),
                      child: const Text('SABnzbd'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          openUrl('https://qbittorrent.jeanmomo.ovh/', context),
                      child: const Text('qBittorrent'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () =>
                          openUrl('https://beszel.jeanmomo.ovh/', context),
                      child: const Text('Beszel'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => openUrl(
                        'https://guillaumejparis.github.io/recipes/',
                        context,
                      ),
                      child: const Text('Basilic'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () =>
                          openUrl('https://authentik.jeanmomo.ovh/', context),
                      child: const Text('Authentik'),
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
