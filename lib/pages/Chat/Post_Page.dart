import 'dart:convert';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPage extends StatefulWidget {
  const PostPage({
    super.key, 
    required this.title, 
    required this.descirpition, 
    required this.post
  });
  
  final String title;
  final String descirpition;
  final PostData post;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isLiked = false;
  int _currentImagePage = 0;
  
  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }
  
  void _checkLikeStatus() {
    final userId = context.read<UserProvider>().currentUser.id;
    isLiked = widget.post.likes.contains(userId);
  }
  
  void _handleLike() async {
    final userId = context.read<UserProvider>().currentUser.id;
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(userId);
        Firestore.unLikePost(widget.post, context);
      } else {
        widget.post.likes.add(userId);
        Firestore.likePost(widget.post, context);
      }
      isLiked = !isLiked;
    });
  }
  
  void _addComment() async {
    if (_commentController.text.isEmpty) return;

    final comment = CommentData()
      ..content = _commentController.text
      ..uid = context.read<UserProvider>().currentUser.id
      ..time = DateTime.now().millisecondsSinceEpoch
      ..id = DateTime.now().millisecondsSinceEpoch.toString();

    await Firestore.addComment(comment, widget.post);
    widget.post.comments.add(comment);
    _commentController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppUi.backgroundDark,
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: AppUi.backgroundDark,
        title: Text(
          "Post Details",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post header with user info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppUi.grey.withOpacity(0.2),
                    child: widget.post.user.pfp.isEmpty 
                      ? Text(
                          widget.post.user.firstName[0].toUpperCase(),
                          style: TextStyle(
                            color: AppUi.offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : ClipOval(
                          child: Image.memory(
                            base64Decode(widget.post.user.pfp),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                          ),
                        ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.post.user.firstName} ${widget.post.user.lastName}",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.post.date)),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppUi.grey.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Post title
            if (widget.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppUi.offWhite,
                  ),
                ),
              ),
            
            // Post description
            if (widget.descirpition.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.descirpition,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppUi.offWhite.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ),
            
            // Post images
            if (widget.post.pics.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: _buildImageGallery(),
              ),
            
            // Like and comment counts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "${widget.post.likes.length} likes",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppUi.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "${widget.post.comments.length} comments",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppUi.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Like and comment buttons
            Divider(color: AppUi.grey.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _handleLike,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppUi.error : AppUi.grey.withOpacity(0.7),
                    ),
                    label: Text(
                      "Like",
                      style: TextStyle(
                        color: isLiked ? AppUi.error : AppUi.grey.withOpacity(0.7),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Focus on comment field
                      FocusScope.of(context).requestFocus(FocusNode());
                      _commentController.clear();
                    },
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: AppUi.grey.withOpacity(0.7),
                    ),
                    label: Text(
                      "Comment",
                      style: TextStyle(
                        color: AppUi.grey.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppUi.grey.withOpacity(0.2)),
            
            // Add comment section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppUi.grey.withOpacity(0.2),
                    child: context.read<UserProvider>().currentUser.pfp.isEmpty
                        ? Text(
                            context.read<UserProvider>().currentUser.firstName[0].toUpperCase(),
                            style: TextStyle(
                              color: AppUi.offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                              base64Decode(context.read<UserProvider>().currentUser.pfp),
                              fit: BoxFit.cover,
                              width: 36,
                              height: 36,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(color: AppUi.offWhite),
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: AppUi.grey.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppUi.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppUi.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppUi.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppUi.primary),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
            
            // Comments list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Comments",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppUi.offWhite,
                ),
              ),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.post.comments[index];
                return FutureBuilder<UserData?>(
                  future: Firestore.getUser(comment.uid),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppUi.grey.withOpacity(0.2),
                            child: user?.pfp.isEmpty ?? true
                                ? Text(
                                    user?.firstName[0].toUpperCase() ?? "U",
                                    style: TextStyle(
                                      color: AppUi.offWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.memory(
                                      base64Decode(user!.pfp),
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user?.firstName ?? "Unknown User",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppUi.offWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      timeago.format(DateTime.fromMillisecondsSinceEpoch(comment.time)),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppUi.grey.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.content,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppUi.offWhite.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageGallery() {
    if (widget.post.pics.isEmpty) return const SizedBox.shrink();

    final PageController controller = PageController();

    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppUi.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  _currentImagePage = index;
                });
              },
              itemCount: widget.post.pics.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Optional: Add image viewing functionality here
                  },
                  child: Image.memory(
                    base64Decode(widget.post.pics[index]),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.post.pics.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.post.pics.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImagePage == index 
                        ? AppUi.primary 
                        : AppUi.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}