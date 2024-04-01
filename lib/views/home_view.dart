import 'package:attraxiachat/controllers/chat/chat_cubit.dart';
import 'package:attraxiachat/controllers/home/home_cubit.dart';
import 'package:attraxiachat/controllers/home/home_state.dart';
import 'package:attraxiachat/views/chats_view.dart';
import 'package:attraxiachat/views/first_user_view.dart';
import 'package:attraxiachat/views/second_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<HomeCubit>(context);
        return Scaffold(
          body: cubit.currentPageIndex == 0
              ? const FirstUserView()
              : const SecondUserView(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatView(
                    senderID: cubit.currentPageIndex == 0 ? "first" : "second",
                    chatID: BlocProvider.of<ChatCubit>(context).createChatId(),
                  ),
                ),
              );
            },
            label: const Text(
              "Start new chat",
              style: TextStyle(fontSize: 18),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: NavigationBar(
              elevation: 0,
              selectedIndex: cubit.currentPageIndex,
              onDestinationSelected: (index) => cubit.setPageIndex(index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.person_2),
                  label: "1st user",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "2nd user",
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, HomeState state) {},
    );
  }
}
