import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';

class SupabaseService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Call this once at app startup. Replace the placeholders with your values.
  static Future<void> init() async {
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'YOUR_SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'YOUR_SUPABASE_ANON_KEY');
    if (!Supabase.instance.hasInitialized) {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
    }
  }

  // Auth helpers
  static User? currentUser() => _client.auth.currentUser;

  static Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Signs up a user. Throws [Exception] on failure with a readable message.
  static Future<User?> signUp(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('Sign up failed: no user returned');
      return user;
    } catch (e) {
      throw Exception('Sign up error: ${e.toString()}');
    }
  }

  /// Signs in a user. Throws [Exception] on failure with a readable message.
  static Future<User?> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('Sign in failed: invalid credentials');
      return user;
    } catch (e) {
      throw Exception('Sign in error: ${e.toString()}');
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // CRUD scoped to current user
  static Future<List<Item>> fetchItems() async {
    final user = currentUser();
    if (user == null) return [];
    try {
      final res = await _client.from('items').select().eq('user_id', user.id).order('created_at', ascending: false).execute();
      final dyn = res as dynamic;
      final data = dyn.data as List<dynamic>?;
      if (data == null) return [];
      return data.map((e) => Item.fromMap(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: ${e.toString()}');
    }
  }

  static Future<String?> uploadImage(Uint8List bytes, String filename) async {
    try {
      final id = const Uuid().v4();
      final path = 'uploads/$id-$filename';
      await _client.storage.from('public').uploadBinary(path, bytes);
      final url = _client.storage.from('public').getPublicUrl(path);
      return url;
    } catch (e) {
      throw Exception('Upload failed: ${e.toString()}');
    }
  }

  static Future<bool> createItem(String title, {Uint8List? imageBytes, String? filename}) async {
    final user = currentUser();
    if (user == null) throw Exception('Not authenticated');
    try {
      String? imageUrl;
      if (imageBytes != null && filename != null) {
        imageUrl = await uploadImage(imageBytes, filename);
      }
      final res = await _client.from('items').insert({'title': title, 'image_url': imageUrl, 'user_id': user.id}).execute();
      final dyn = res as dynamic;
      if (dyn.error != null) throw Exception('Insert failed: ${dyn.error}');
      return true;
    } catch (e) {
      throw Exception('Failed to create item: ${e.toString()}');
    }
  }
}
