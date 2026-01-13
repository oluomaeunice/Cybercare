import 'dart:io';
import 'package:chewie/chewie.dart'; // Add this package
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Add this package
import 'package:video_player/video_player.dart'; // Add this package

class TopicViewerScreen extends StatefulWidget {
  final TopicModel topic;

  const TopicViewerScreen({super.key, required this.topic});

  @override
  State<TopicViewerScreen> createState() => _TopicViewerScreenState();
}

class _TopicViewerScreenState extends State<TopicViewerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.topic.type == 'video' && widget.topic.videoUrl != null) {
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    setState(() => _isLoading = true);
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.topic.videoUrl!),
      );
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      setState(() {});
    } catch (e) {
      debugPrint("Error loading video: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.topic.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      // Bottom Button to "Finish" the lesson
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // Popping sends the user back, triggering the "Mark Completed" logic
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Complete Lesson",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: widget.topic.type == 'video' ? _buildVideoView() : _buildTextView(),
    );
  }

  Widget _buildVideoView() {
    if (widget.topic.videoUrl == null) {
      return const Center(child: Text("Video URL is missing."));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chewieController != null && _videoController!.value.isInitialized) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          ),
          const SizedBox(height: 20),
          Expanded(
            // <--- Takes up remaining space
            child: SingleChildScrollView(
              // <--- Makes only the text scrollable
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MarkdownBody(
                  data: widget.topic.content,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        p: TextStyle(color: AppColors.primaryDark),
                        h1: TextStyle(color: AppColors.primaryDark),
                        h2: TextStyle(color: AppColors.primaryDark),
                        h3: TextStyle(color: AppColors.primaryDark),
                        listBullet: TextStyle(color: AppColors.primaryDark),
                      ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text("Could not load video."));
    }
  }

  Widget _buildTextView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: MarkdownBody(
        data: widget.topic.content,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
