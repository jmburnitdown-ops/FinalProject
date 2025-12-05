import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/supabase_service.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    items = await SupabaseService.fetchItems();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Items'),
            if (user != null && user.email != null) Text(user.email!, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await SupabaseService.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? ListView(
                    children: [Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No items yet.')))],
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final it = items[i];
                      return ListTile(
                        leading: it.imageUrl != null ? Image.network(it.imageUrl!, width: 56, height: 56, fit: BoxFit.cover) : null,
                        title: Text(it.title),
                        subtitle: Text(it.createdAt.toLocal().toString()),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddItemScreen()));
          if (created == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
