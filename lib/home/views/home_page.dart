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
      create: (context) => HomeCubit(Injector.di.get<HomeRepository>()),
      child:  _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  _HomeView({super.key});

  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == HomeStatus.loading) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Loading...'),));
        }

        if (state.status == HomeStatus.loaded) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Loaded...${state.searchCategory}'),));
          Navigator.of(context).pushNamed(ChatPage.route);
        }

        if (state.status == HomeStatus.error) {
          final error = state.extra['error'] as String;
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Error... $error'),));
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text('Superchat'),
              const SizedBox(height: 20,),
              Text('Hang out with strangers online'),
              const SizedBox(height: 20,),
              StreamBuilder<int>(
                stream: context.read<HomeCubit>().getActiveUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Users online: ${snapshot.data}');
                  }
                  return const SizedBox.shrink();
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7 , 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            hintText: 'School, Coding, Anime, etc...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 3,),
                        const Text('Search for a category', style: TextStyle(fontSize: 9),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,),
                    child: IconButton(
                      iconSize: 30.0,
                      onPressed: () {
                        context.read<HomeCubit>().searchCategory(category: categoryController.text);
                      }, 
                      icon: const Icon(Icons.send_outlined),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}