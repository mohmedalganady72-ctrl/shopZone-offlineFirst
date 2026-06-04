import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/products_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F8FF),
        fontFamily: 'Roboto',
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_bag_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Shop',
                    style: TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Zone',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ProductsProvider>(
            builder: (_, provider, __) {
              // Show offline icon in top bar too
              if (provider.isOffline) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.wifi_off_rounded,
                      color: Color(0xFFFF9800), size: 22),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFF0EEFF),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront,
                  color: Color(0xFF6C63FF)),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Consumer<ProductsProvider>(
                builder: (_, provider, __) {
                  final count = provider.favorites.length;
                  if (count == 0) {
                    return const Icon(Icons.favorite_border);
                  }
                  return Badge(
                    label: Text('$count'),
                    backgroundColor: const Color(0xFFFF4B6E),
                    child: const Icon(Icons.favorite_border),
                  );
                },
              ),
              selectedIcon: Consumer<ProductsProvider>(
                builder: (_, provider, __) {
                  final count = provider.favorites.length;
                  if (count == 0) {
                    return const Icon(Icons.favorite,
                        color: Color(0xFF6C63FF));
                  }
                  return Badge(
                    label: Text('$count'),
                    backgroundColor: const Color(0xFFFF4B6E),
                    child: const Icon(Icons.favorite,
                        color: Color(0xFF6C63FF)),
                  );
                },
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
