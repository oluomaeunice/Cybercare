import 'dart:io';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/init_dependencies.dart';
import 'package:file_picker/file_picker.dart'; // Make sure this is in pubspec
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddContentScreen extends StatefulWidget {
  final String moduleId;
  final String moduleTitle;

  const AddContentScreen({super.key, required this.moduleId, required this.moduleTitle});

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  String _type = 'text'; // 'text' or 'video'
  File? _videoFile;
  bool _isUploading = false;
  int _topicCount = 1; // Simplistic ordering

  void _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() => _videoFile = File(result.files.single.path!));
    }
  }

  void _addTopic() async {
    if (_titleCtrl.text.isEmpty) return;
    if (_type == 'video' && _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please pick a video")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      final repo = ModuleRepository(serviceLocator());

      await repo.addTopic(
        topic: TopicModel(
          moduleId: widget.moduleId,
          title: _titleCtrl.text.trim(),
          type: _type,
          content: _contentCtrl.text.trim(), // Markdown description of video or text content
          orderIndex: _topicCount,
        ),
        videoFile: _videoFile,
      );

      // Success Reset
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Topic Added!")));
      setState(() {
        _isUploading = false;
        _topicCount++;
        _titleCtrl.clear();
        _contentCtrl.clear();
        _videoFile = null;
        _type = 'text';
      });

    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add to: ${widget.moduleTitle}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Topic #$_topicCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Topic Type Selector
            Row(
              children: [
                _buildTypeChip('text', Iconsax.document_text),
                const SizedBox(width: 10),
                _buildTypeChip('video', Iconsax.video_play),
              ],
            ),
            const SizedBox(height: 20),

            // Form
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: "Topic Title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),

            if (_type == 'video') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Iconsax.video_circle, size: 40, color: _videoFile != null ? Colors.green : Colors.grey),
                    const SizedBox(height: 8),
                    Text(_videoFile != null ? _videoFile!.path.split('/').last : "No video selected"),
                    TextButton(onPressed: _pickVideo, child: const Text("Select Video File")),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],

            TextField(
              controller: _contentCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: _type == 'video' ? "Video Description (Markdown)" : "Article Content (Markdown)",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _addTopic,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload Topic", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            Center(
              child: TextButton(
                onPressed: () {
                  // Finish flow, go back to main screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Finish & Exit", style: TextStyle(color: Colors.red)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSelected = _type == type;
    return ChoiceChip(
      label: Row(children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(type.toUpperCase())]),
      selected: isSelected,
      selectedColor: AppColors.primaryLight,
      onSelected: (val) => setState(() => _type = type),
    );
  }
}