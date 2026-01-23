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

bool loginSuccess = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await manager.init();
  loginSuccess = manager.currentUser != null;
  print('loginSuccess: $loginSuccess');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription? _userSub;
  bool _loginComplete = true;

  String? _loginError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userSub = manager.userChanges().listen((user) {
      print('User changed: $user');
      if (user != null) {
        loginSuccess = true;
        setState(() {
          _loginComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _userSub?.cancel();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      try {
        if (await manager.refreshToken() == null) {
          loginSuccess = false;
        }
      } catch (e) {
        loginSuccess = false;
        setState(() {
          _loginComplete = true;
          _loginError = e.toString();
        });
      }
    }
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
        _loginComplete = true;
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
      homeWidget = HomePage((url) => openUrl(url, context));
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
  const HomePage(this.onOpenUrl, {super.key});
  final void Function(String url) onOpenUrl;
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
                      onPressed: () => onOpenUrl('https://bw.jeanmomo.ovh/'),
                      child: const Text('Bitwarden'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          onOpenUrl('https://nextcloud.jeanmomo.ovh/'),
                      child: const Text('Nextcloud'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => onOpenUrl('https://ha.jeanmomo.ovh/'),
                  child: const Text('Home Assistant'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          onOpenUrl('https://radarr.jeanmomo.ovh/'),
                      child: const Text('Radarr'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          onOpenUrl('https://sonarr.jeanmomo.ovh/'),
                      child: const Text('Sonarr'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => onOpenUrl('https://jellyfin.jeanmomo.ovh/'),
                  child: const Text('Jellyfin'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          onOpenUrl('https://sabnzbd.jeanmomo.ovh/'),
                      child: const Text('SABnzbd'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          onOpenUrl('https://qbittorrent.jeanmomo.ovh/'),
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
                          onOpenUrl('https://beszel.jeanmomo.ovh/'),
                      child: const Text('Beszel'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => onOpenUrl(
                        'https://guillaumejparis.github.io/recipes/',
                      ),
                      child: const Text('Basilic'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () =>
                          onOpenUrl('https://authentik.jeanmomo.ovh/'),
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
