import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/chat/chat.dart';

import 'package:superchat/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String route = "/";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeInjector.di.get<HomeRepository>())..getUser(),
      child:  _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  _HomeView({super.key});

  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == HomeStatus.loading) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('Loading...'),));
        }

        if (state.status == HomeStatus.loaded) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Loaded...${state.searchCategory}'),));
          Navigator.of(context).pushNamed(ChatPage.route, arguments: {'category': state.searchCategory});
        }

        if (state.status == HomeStatus.error) {
          final error = state.extra['error'] as String;
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Error... $error'),));
        }
      },
      builder:(context, state) {
        if (state.status == HomeStatus.userLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == HomeStatus.userLoaded) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text('Superchat'),
                  const SizedBox(height: 20,),
                  Text('chat with strangers'),
                  const SizedBox(height: 20,),
                  StreamBuilder<int>(
                    stream: context.read<HomeCubit>().getActiveUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 0) {
                          return const Text('No one seems to be here. Invite your friends');
                        }
                        return Text('Users online: ${snapshot.data}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),
                  CategoryChatInput(
                    hint: 'School, Coding, Anime, etc...',
                    controller: categoryController, 
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        }

        if (state.status == HomeStatus.userError) {
          return Scaffold(
            body: Center(
              child: Text('An error occured\n${state.extra['error']}'),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}