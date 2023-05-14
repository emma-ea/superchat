import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/core_utils/constants.dart';

import 'package:superchat/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String route = "/";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeInjector.di.get<HomeRepository>())..getUser(),
      child:  const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {

  final categoryController = TextEditingController();

  @override
  void dispose() {
    context.read<HomeCubit>().updateUserStatus(
      userId: context.read<HomeCubit>().state.userId,
    );
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      context.read<HomeCubit>().updateUserStatus(
        userId: context.read<HomeCubit>().state.userId,
      );
    }

    if (state == AppLifecycleState.resumed) {
      context.read<HomeCubit>().updateUserStatus(
        userId: context.read<HomeCubit>().state.userId,
        isActive: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = context.select((HomeCubit cubit) => cubit.state);

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == HomeStatus.loading) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('finding users interested...'),));
        }

        if (state.status == HomeStatus.loaded) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('opening chat for ${state.searchCategory}'),));
          Navigator.of(context).push(ChatPage.routeWithParams(state.searchCategory));
        }

        if (state.status == HomeStatus.error) {
          final error = state.extra['error'] as String;
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('an error occurred: $error'),));
        }
      },
      child: user.status == HomeStatus.userLoading
      ? const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      )
      : Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('USER ID: ${user.userId}', style: const TextStyle(color: Colors.black, fontSize: 12),),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text('Superchat'),
              const SizedBox(height: 20,),
              const Text('chat with strangers'),
              const SizedBox(height: 20,),
              StreamBuilder<int>(
                stream: context.read<HomeCubit>().getActiveUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 0) {
                      return const Text(AppConstants.emptyRoomInviteFriends);
                    }
                    return Text('Users online: ${snapshot.data}');
                  }
                  return const SizedBox.shrink();
                },
              ),
              const Spacer(),
              CategoryChatInput(
                hint: AppConstants.topicHints,
                controller: categoryController, 
                onTap: () {
                  context.read<HomeCubit>().searchCategory(category: categoryController.text);
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}