import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/device_utility.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:cybercare/features/resources/view/resourcewidget/circular_icon_button.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfResourceScreen extends StatelessWidget {
  static route(ResourcePost resource) => MaterialPageRoute(
      builder: (context) => PdfResourceScreen(resource: resource));

  final ResourcePost resource;

  const PdfResourceScreen({super.key, required this.resource});

  // Helper to open PDF in external app (browser/native viewer)
  Future<void> _downloadPdf() async {
    if (resource.fileUrl != null) {
      final Uri url = Uri.parse(resource.fileUrl!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A Floating button is great for PDFs so users can save/download them
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _downloadPdf,
        backgroundColor: AppColors.primaryDark,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: const Text("Open / Download", style: TextStyle(color: Colors.white)),
      ),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),

          // 1. Description Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About this Document",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.description, // Show the short description
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                ],
              ),
            ),
          ),

          // 2. The PDF Viewer
          // SliverFillRemaining makes the PDF take up all leftover space
          // and allows it to be scrollable along with the header.
          SliverFillRemaining(
            hasScrollBody: true, // Important: lets the PDF handle its own internal scrolling
            child: Container(
              color: const Color(0xFFF5F5F7), // Slightly grey bg for contrast against white paper
              child: resource.fileUrl != null
                  ? const PDF(
                swipeHorizontal: false, // Vertical scrolling feels more native here
                enableSwipe: true,
                fitPolicy: FitPolicy.BOTH,
              ).cachedFromUrl(
                resource.fileUrl!,
                placeholder: (progress) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primaryDark),
                      const SizedBox(height: 10),
                      Text('$progress %', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
                errorWidget: (error) => Center(
                  child: Text("Error loading PDF: $error"),
                ),
              )
                  : const Center(child: Text("No PDF URL found")),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0, // Slightly shorter than Article screen
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularIconButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Handle image logic
            resource.imageUrl.isNotEmpty
                ? Image.network(
              resource.imageUrl,
              fit: BoxFit.cover,
            )
                : Container(color: AppColors.primaryDark), // Fallback color

            // Gradient Overlay (Darker at bottom for text readability)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.6, 1.0],
                ),
              ),
            ),

            // Title Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PDF Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.document_text, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "PDF DOCUMENT",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${formatDate(resource.createdAt)}', // Use your formatting util
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}