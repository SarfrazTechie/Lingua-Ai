import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../app/theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMessage = 'No camera found on this device.');
        return;
      }
      final controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _controller = controller;
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Camera could not be started.');
    }
  }

  Future<void> _captureAndExtract() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isProcessing) {
      return;
    }
    setState(() => _isProcessing = true);
    try {
      final file = await controller.takePicture();
      debugPrint('CAMERA: photo taken at ' + file.path);
      final inputImage = InputImage.fromFile(File(file.path));
      final recognizer = TextRecognizer();
      final result = await recognizer.processImage(inputImage);
      await recognizer.close();
      final extractedText = result.text.trim();
      debugPrint('CAMERA EXTRACTED: ' + extractedText);
      if (!mounted) return;
      if (extractedText.isEmpty) {
        _showSnackBar('No text detected. Try again with a clearer image.');
        setState(() => _isProcessing = false);
        return;
      }
      context.pop(extractedText);
    } catch (e, st) {
      debugPrint('CAMERA ERROR: ' + e.toString());
      debugPrint('CAMERA STACK: ' + st.toString());
      if (mounted) {
        _showSnackBar('Failed to process image. Please try again.');
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.body2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview or error
            _buildCameraPreview(),

            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomControls(),
            ),

            // Processing overlay
            if (_isProcessing) _buildProcessingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt_rounded, color: AppColors.textDarkSecondary, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: AppColors.textDarkSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
      );
    }

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize?.height ?? 1,
            height: _controller!.value.previewSize?.width ?? 1,
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),

          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Text(
              'Scan Text',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Flash toggle (placeholder)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: const Icon(Icons.flash_off_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hint text
          Text(
            'Point camera at text and tap capture',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Capture button
          GestureDetector(
            onTap: _isInitialized ? _captureAndExtract : null,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primary,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Extracting text...',
                style: AppTextStyles.body2.copyWith(color: AppColors.textDarkPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

