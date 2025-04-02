import 'dart:convert';

import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostComponent extends StatefulWidget {
  final PostData post;
  final Function()? onDelete;
  final UserData user;

  const PostComponent({
    super.key,
    required this.post,
    this.onDelete,
    required this.user,
  });

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  bool isProfilePic = false;
  bool isImage = false;

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
    _checkProfilePic();
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

  void _checkProfilePic() {
    if (widget.user.pfp.isNotEmpty) {
      isProfilePic = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: AppUi.grey.withOpacity(0.1),
          width: 1,
          style: BorderStyle.none,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppUi.grey.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppUi.primary.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppUi.grey.withOpacity(0.2),
                      child: !isProfilePic 
                        ? Text(
                            widget.user.firstName[0].toUpperCase(),
                            style: TextStyle(
                              color: AppUi.offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                              base64Decode(widget.user.pfp),
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            ),
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
                  if (widget.post.uid == context.read<UserProvider>().currentUser.id)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppUi.error.withOpacity(0.7),
                      ),
                      onPressed: widget.onDelete,
                    ),
                ],
              ),
            ),
            if (widget.post.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (widget.post.description.isNotEmpty && widget.post.pics.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.post.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppUi.offWhite.withOpacity(0.9),
                  ),
                ),
              ),
            if (widget.post.pics.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: _buildImageGallery(),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppUi.error : AppUi.grey.withOpacity(0.7),
                    ),
                    onPressed: _handleLike,
                  ),
                    Text(
                      widget.post.likes.length.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppUi.grey.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: AppUi.grey.withOpacity(0.7),
                      ),
                      onPressed: () {
                        // Implement comment view
                      },
                    ),
                    Text(
                      widget.post.comments.length.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppUi.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      )
    );
  }

  Widget _buildImageGallery() {
    if (widget.post.pics.isEmpty) return const SizedBox.shrink();

    final PageController controller = PageController();
    int _currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) => Column(
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
                    _currentPage = index;
                  });
                },
                itemCount: widget.post.pics.length,
                itemBuilder: (context, index) {
                  return Image.memory(
                    base64Decode(widget.post.pics[index]),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          if (widget.post.pics.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.post.pics.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == index ? 8 : 6,
                    height: _currentPage == index ? 8 : 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index 
                          ? AppUi.primary 
                          : AppUi.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}