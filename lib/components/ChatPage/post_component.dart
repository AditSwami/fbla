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
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      color: AppUi.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppUi.grey.withValues(alpha: .3),
              child: !isProfilePic 
                ? Text(
                    widget.user.firstName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : ClipOval(
                    child: Image.memory(
                      base64Decode(widget.user.pfp),
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          widget.user.firstName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
            ),
            title: Text(
              "${widget.post.user.firstName} ${widget.post.user.lastName}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.post.date)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: widget.post.uid == context.read<UserProvider>().currentUser.id
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: widget.onDelete,
                  )
                : null,
          ),
          if (widget.post.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.post.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          if (widget.post.description.isNotEmpty  && widget.post.pics.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.post.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (widget.post.pics.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 75.0, top: 10),
              child: _buildImageGallery(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? AppUi.error : null,
                  ),
                  onPressed: _handleLike,
                ),
                Text(
                  widget.post.likes.length.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Implement comment view
                  },
                ),
                Text(
                  widget.post.comments.length.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    if (widget.post.pics.isEmpty) return const SizedBox.shrink();

    final PageController controller = PageController();
    int _currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.post.pics.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      base64Decode(widget.post.pics[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.post.pics.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.post.pics.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == index ? 8 : 6,
                    height: _currentPage == index ? 8 : 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index 
                          ? AppUi.primary 
                          : AppUi.grey.withOpacity(0.5),
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