import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_connect_mb/features/auth/presentation/providers/auth_provider.dart';
import 'package:green_connect_mb/generated/l10n.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            fontFamily: 'Roboto', 
            color: Color.fromARGB(255, 42, 128, 40),
            fontWeight: FontWeight.w900, // bold
            fontSize: 22,
          ),
        ),
      ),
      body: Center(
        child: state.when(
          data: (users) {
            if (users.isEmpty) {
              // chưa có data -> show button load
              return ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).getUser();
                },
                child: Text(S.of(context)!.hello),
              );
            }
            // có data -> render list
            return ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Text(user.name),
                );
              },
            );
          },

          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text("Error: $e"),
        ),
      ),
    );
  }
}
