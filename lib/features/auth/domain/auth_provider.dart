// // lib/features/auth/domain/auth_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../data/auth_api.dart';
//
// final authApiProvider = Provider((ref) => AuthApi());
//
// final registerProvider = FutureProvider.family<void, Map<String, String>>((ref, data) {
//   final api = ref.read(authApiProvider);
//   return api.register(
//     email: data['email']!,
//     password: data['password']!,
//     username: data['username']!,
//   );
// });
