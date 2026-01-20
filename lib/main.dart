import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'open_url.dart';

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
        ? kDebugMode
              ? Uri.parse('http://localhost:8962/oidc/redirect.html')
              : Uri.parse('https://www.jeanmomo.ovh/oidc/redirect.html')
        : Uri.parse('ovh.jeanmomo.jeanmomo://callback'),
    scope: ['openid', 'offline_access'],
  ),
);

bool loginSuccess = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await manager.init();
  await manager.userChanges().first.then((user) {
    loginSuccess = user != null;
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _userSub;
  bool _loginComplete = true;
  String? _loginError;

  @override
  void initState() {
    super.initState();
    _userSub = manager.userChanges().listen((user) {
      loginSuccess = user != null;
      setState(() {
        _loginComplete = true;
      });
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  void _doLogin() {
    setState(() {
      _loginComplete = false;
    });
    try {
      manager.loginAuthorizationCodeFlow();
    } catch (e) {
      loginSuccess = false;
      setState(() {
        _loginError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (!_loginComplete) {
      homeWidget = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (!loginSuccess) {
      homeWidget = Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_loginError != null && _loginError!.isNotEmpty)
                Text('Login failed: $_loginError'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _doLogin();
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    } else {
      homeWidget = const HomePage();
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
      home: homeWidget,
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
