import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../model/give.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<give> _drinks = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _fetchCount = 5;

  @override
  void initState() {
    super.initState();
    _fetchDrinks();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchDrinks() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      for (int i = 0; i < _fetchCount; i++) {
        final response = await http.get(
          Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/random.php"),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          var drinkData = (data['drinks'] as List).first;
          setState(() {
            _drinks.add(give.fromJson(drinkData));
          });
        } else {
          throw Exception("Failed to load drinks");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load drinks: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      _fetchDrinks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        backgroundColor: Colors.black,
        body: ListView.builder(
          controller: _scrollController,
          itemCount: _drinks.length + 1,
          itemBuilder: (context, index) {
            if (index == _drinks.length) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox.shrink();
            }
            final drink = _drinks[index];
            return GestureDetector(
              onTap: () {
                context.go('/drink/${drink.name}');
              },
              child: Card(
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          drink.url,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        drink.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/list');
                  break;
                case 2:
                  context.go('/search');
                  break;
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list),
              label: 'List',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.blue,
            ),
          ],
        ));
  }
}
