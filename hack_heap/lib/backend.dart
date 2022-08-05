import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Appwrite Providers
final appwriteClientProvider = Provider<Client>(
  (ref) => Client()
  ..setEndpoint('http://146.190.15.12/v1')
  ..setProject('hackheap')
);
final appwriteDatabaseProvider = Provider<Databases>(
  (ref) => Databases(ref.watch(appwriteClientProvider), databaseId: 'default')
);

// -> Hackathons Provider 
final hackathonsCIDProvider = Provider<String>((ref) => 'hackathons');