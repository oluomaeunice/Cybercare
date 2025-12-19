import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<File?> pickImage() async {
  try {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      return File(xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

int calculateReadingTime(String content) {
  // Average reading speed in words per minute (standard is 200-250 for adults)
  const averageReadingSpeed = 225;

  // Remove extra whitespace and split into words
  final words = content.trim().split(RegExp(r'\s+'));

  // Filter out empty strings that might occur from multiple spaces
  final wordCount = words.where((word) => word.isNotEmpty).length;

  // Calculate reading time in minutes, rounding up
  final readingTime = (wordCount / averageReadingSpeed).ceil();

  // Ensure at least 1 minute reading time for very short content
  return readingTime < 1 ? 1 : readingTime;
}

String formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
  // For full month name: DateFormat('MMMM d, y').format(date)
}

