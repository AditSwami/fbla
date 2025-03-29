import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:fbla_2025/pages/Chat/AddChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/ChatPage/post_component.dart';
import 'package:provider/provider.dart';
import 'package:fbla_2025/components/Buttons/button.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    await context.read<UserProvider>().loadPosts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<UserProvider>().posts;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                automaticallyImplyLeading: false,
                backgroundColor: AppUi.backgroundDark,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Study Groups",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Button(
                              height: 35,
                              width: 125,
                              color: AppUi.primary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => const AddChatPage()),
                                );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Post',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Icon(Icons.add, color: AppUi.offWhite, size: 20)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: SizedBox(
                          width: 365,
                          child: CupertinoSearchTextField(
                            backgroundColor: AppUi.grey.withValues(alpha: .1),
                            style: Theme.of(context).textTheme.bodyMedium,
                            onChanged: (value) => {},
                            onSubmitted: (value) {},
                            placeholder: 'Search',
                          ),
                        ), 
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: posts.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 48,
                                color: AppUi.grey.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppUi.grey.withOpacity(0.5),
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Be the first to start a discussion!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppUi.grey.withOpacity(0.5),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8.0),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostComponent(
                            post: posts[index],
                            user: posts[index].user,
                            onDelete: () async {
                              await Firestore.deletePost(posts[index]);
                              _loadPosts();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GroupChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppUi.primary : AppUi.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}

class ClassGroupChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const ClassGroupChip({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppUi.primary : AppUi.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
