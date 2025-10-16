import 'package:GreenConnectMobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            color: Color.fromARGB(255, 56, 235, 53),
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
                  trailing: GradientButton(text: 'Login', onPressed: () {}),
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
