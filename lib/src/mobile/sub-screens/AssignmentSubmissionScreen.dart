import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/components/RouteName.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Assignment assignment;
  const AssignmentSubmissionScreen({
    super.key,
    required this.assignment,
    required this.onNext,
    required this.onPrevious,
  });

  static const primary = Color(0xFF3CC2DD);
  static const border = Color(0xFFE8F0F2);
  static const muted = Color(0xFF538893);

  @override
  State<AssignmentSubmissionScreen> createState() =>
      _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState
    extends State<AssignmentSubmissionScreen> {
  final TextEditingController _commentsController = TextEditingController();
  final List<UploadedFile> _uploadedFiles = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: widget.assignment.acceptedFormats
          .map((e) => e.replaceAll('.', ''))
          .toList(),
    );

    if (result != null) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Simulate upload progress
      for (int i = 0; i <= 100; i += 5) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (mounted) {
          setState(() {
            _uploadProgress = i / 100;
          });
        }
      }

      setState(() {
        for (var file in result.files) {
          _uploadedFiles.add(UploadedFile(
            name: file.name,
            size: _formatBytes(file.size),
            progress: 1.0,
          ));
        }
        _isUploading = false;
      });
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  Future<void> _submitAssignment() async {
    if (_uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Assignment?'),
        content: const Text(
          'Are you sure you want to submit this assignment? You won\'t be able to edit it after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AssignmentSubmissionScreen.primary,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Simulate submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Assignment submitted successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        widget.assignment.isSubmitted = true;
      });
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 12),
            Text('Draft saved successfully!'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _MainContent(
                        assign: widget.assignment,
                        uploadedFiles: _uploadedFiles,
                        isUploading: _isUploading,
                        uploadProgress: _uploadProgress,
                        commentsController: _commentsController,
                        onPickFiles: _pickFiles,
                        onRemoveFile: _removeFile,
                        onSubmit: _submitAssignment,
                        onSaveDraft: _saveDraft,
                      )),
                      const SizedBox(width: 32),
                      SizedBox(
                        width: 320,
                        child: _Sidebar(
                          assign: widget.assignment,
                          onNext: widget.onNext,
                          onPrevious: widget.onPrevious,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _MainContent(
                        assign: widget.assignment,
                        uploadedFiles: _uploadedFiles,
                        isUploading: _isUploading,
                        uploadProgress: _uploadProgress,
                        commentsController: _commentsController,
                        onPickFiles: _pickFiles,
                        onRemoveFile: _removeFile,
                        onSubmit: _submitAssignment,
                        onSaveDraft: _saveDraft,
                      ),
                      const SizedBox(height: 24),
                      _Sidebar(
                        assign: widget.assignment,
                        onNext: widget.onNext,
                        onPrevious: widget.onPrevious,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UploadedFile {
  final String name;
  final String size;
  final double progress;

  UploadedFile({
    required this.name,
    required this.size,
    required this.progress,
  });
}

/* ===========================================================
   MAIN CONTENT
=========================================================== */

class _MainContent extends StatelessWidget {
  final Assignment assign;
  final List<UploadedFile> uploadedFiles;
  final bool isUploading;
  final double uploadProgress;
  final TextEditingController commentsController;
  final VoidCallback onPickFiles;
  final Function(int) onRemoveFile;
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;

  const _MainContent({
    super.key,
    required this.assign,
    required this.uploadedFiles,
    required this.isUploading,
    required this.uploadProgress,
    required this.commentsController,
    required this.onPickFiles,
    required this.onRemoveFile,
    required this.onSubmit,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RouteName(),
        const SizedBox(height: 24),
        _Header(assign: assign),
        const SizedBox(height: 24),
        _InstructionsCard(assign: assign),
        const SizedBox(height: 24),
        _DropZone(onPickFiles: onPickFiles),
        const SizedBox(height: 24),
        if (uploadedFiles.isNotEmpty) ...[
          ...uploadedFiles.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _UploadedFileCard(
              file: entry.value,
              onRemove: () => onRemoveFile(entry.key),
            ),
          )),
          const SizedBox(height: 12),
        ],
        if (isUploading)
          _UploadProgress(progress: uploadProgress),
        if (isUploading)
          const SizedBox(height: 24),
        _CommentsBox(controller: commentsController),
        const SizedBox(height: 32),
        _ActionButtons(
          onSubmit: onSubmit,
          onSaveDraft: onSaveDraft,
          isSubmitted: assign.isSubmitted ?? false,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Assignment assign;
  const _Header({super.key, required this.assign});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assign.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3CC2DD),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event, size: 16, color: Color(0xFF538893)),
                    const SizedBox(width: 6),
                    Text(
                      "Due: ${_formatDate(assign.dueDate)}",
                      style: const TextStyle(color: Color(0xFF538893)),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.grade, size: 16, color: Color(0xFF538893)),
                    const SizedBox(width: 6),
                    Text(
                      "${assign.totalPoints} Points",
                      style: const TextStyle(color: Color(0xFF538893)),
                    ),
                  ],
                ),
              ],
            ),
            if (!isNarrow) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Assignment Rubric'),
                      content: const Text(
                        'Rubric details would be displayed here.\n\n'
                        'This is a placeholder for the actual rubric content.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.description),
                label: const Text("View Rubric"),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}

class _InstructionsCard extends StatelessWidget {
  final Assignment assign;
  const _InstructionsCard({super.key, required this.assign});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF3CC2DD)),
              SizedBox(width: 8),
              Text(
                "Instructions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assign.description,
            style: const TextStyle(color: Color(0xFF538893), height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.folder,
                label: 'Accepted: ${assign.acceptedFormats.join(", ")}',
              ),
              _InfoChip(
                icon: Icons.data_usage,
                label: 'Max size: ${assign.maxFileSizeMB}MB',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3CC2DD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF3CC2DD)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF538893),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropZone extends StatefulWidget {
  final VoidCallback onPickFiles;

  const _DropZone({required this.onPickFiles});

  @override
  State<_DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<_DropZone> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPickFiles,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHovering
                  ? const Color(0xFF3CC2DD)
                  : const Color(0xFF3CC2DD).withOpacity(0.4),
              width: _isHovering ? 2 : 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(16),
            color: _isHovering
                ? const Color(0xFF3CC2DD).withOpacity(0.05)
                : null,
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload,
                size: 48,
                color: _isHovering
                    ? const Color(0xFF3CC2DD)
                    : const Color(0xFF3CC2DD).withOpacity(0.7),
              ),
              const SizedBox(height: 12),
              const Text(
                "Drag and drop files here or click to browse",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Accepted formats: .pdf, .docx, .pka (Max 25MB)",
                style: TextStyle(color: Color(0xFF538893)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadedFileCard extends StatelessWidget {
  final UploadedFile file;
  final VoidCallback onRemove;

  const _UploadedFileCard({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Color(0xFF3CC2DD)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  file.size,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            color: Colors.grey.shade600,
            tooltip: 'Remove file',
          ),
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  final double progress;

  const _UploadProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.upload_file, color: Color(0xFF3CC2DD)),
                  SizedBox(width: 8),
                  Text("Uploading..."),
                ],
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3CC2DD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3CC2DD)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsBox extends StatelessWidget {
  final TextEditingController controller;

  const _CommentsBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Submission Comments (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Add a note for your instructor...",
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3CC2DD)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;
  final bool isSubmitted;

  const _ActionButtons({
    required this.onSubmit,
    required this.onSaveDraft,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;
        
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isSubmitted) ...[
                OutlinedButton(
                  onPressed: onSaveDraft,
                  child: const Text("Save Draft"),
                ),
                const SizedBox(height: 12),
              ],
              ElevatedButton.icon(
                onPressed: isSubmitted ? null : onSubmit,
                icon: Icon(isSubmitted ? Icons.check : Icons.send),
                label: Text(isSubmitted ? "Submitted" : "Submit Assignment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitted 
                      ? Colors.green 
                      : const Color(0xFF3CC2DD),
                  disabledBackgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          );
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isSubmitted) ...[
              TextButton(
                onPressed: onSaveDraft,
                child: const Text("Save Draft"),
              ),
              const SizedBox(width: 16),
            ],
            ElevatedButton.icon(
              onPressed: isSubmitted ? null : onSubmit,
              icon: Icon(isSubmitted ? Icons.check : Icons.send),
              label: Text(isSubmitted ? "Submitted" : "Submit Assignment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubmitted 
                    ? Colors.green 
                    : const Color(0xFF3CC2DD),
                disabledBackgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ===========================================================
   SIDEBAR
=========================================================== */

class _Sidebar extends StatelessWidget {
  final Assignment assign;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const _Sidebar({
    super.key,
    required this.assign,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SUBMISSION STATUS",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: Color(0xFF538893),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    assign.isSubmitted == true
                        ? Icons.check_circle
                        : Icons.history_toggle_off,
                    size: 36,
                    color: assign.isSubmitted == true ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assign.isSubmitted == true ? "Submitted" : "Not Submitted",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: assign.isSubmitted == true ? Colors.green : Colors.black,
                          ),
                        ),
                        Text(
                          assign.isSubmitted == true
                              ? "Awaiting grading"
                              : "First attempt pending",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _Card(
          child: Column(
            children: [
              Text(
                assign.isSubmitted == true
                    ? "Submission recorded. Check back for feedback."
                    : "No previous submissions found.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _Card(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text(
                    'Previous Assignment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text(
                    'Next Assignment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ===========================================================
   SHARED CARD
=========================================================== */

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0F2)),
      ),
      child: child,
    );
  }
}