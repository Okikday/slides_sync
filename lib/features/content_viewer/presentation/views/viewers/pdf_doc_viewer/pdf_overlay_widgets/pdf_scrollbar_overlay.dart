import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'dart:math' as math;

class PdfScrollbarOverlay extends StatefulWidget {
  final PdfViewerController controller;
  final Duration animationDuration;

  const PdfScrollbarOverlay({
    required this.controller,
    this.animationDuration = const Duration(milliseconds: 200),
    super.key,
  });

  @override
  State<PdfScrollbarOverlay> createState() => _PdfScrollbarOverlayState();
}

class _PdfScrollbarOverlayState extends State<PdfScrollbarOverlay>
    with SingleTickerProviderStateMixin {
  static const double _circleSize = 48.0;
  
  double _dragProgress = 0.0;
  bool _isDragging = false;
  bool _isVisible = false;
  int? _currentPage;
  int? _pageCount;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _syncFromController();
    widget.controller.addListener(_onControllerChange);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  void _onControllerChange() {
    if (!mounted) return;
    
    // Get current page and page count from the controller
    final currentPage = widget.controller.pageNumber;
    final pageCount = widget.controller.pages?.length;
    
    setState(() {
      _currentPage = currentPage;
      _pageCount = pageCount;
      if (!_isDragging && pageCount != null && pageCount > 0 && currentPage != null) {
        _dragProgress = ((currentPage.clamp(1, pageCount)).toDouble() - 1) / math.max(1, pageCount - 1);
      }
    });
    
    _showScrollbar();
  }

  void _syncFromController() {
    final currentPage = widget.controller.pageNumber;
    final pageCount = widget.controller.pages?.length;
    _currentPage = currentPage;
    _pageCount = pageCount;
    if (pageCount != null && pageCount > 0 && currentPage != null) {
      _dragProgress = ((currentPage.clamp(1, pageCount)).toDouble() - 1) / math.max(1, pageCount - 1);
    }
  }

  void _showScrollbar() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
      _animationController.forward();
      
      // Auto-hide after 2 seconds if not dragging
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && !_isDragging) {
          _hideScrollbar();
        }
      });
    }
  }

  void _hideScrollbar() {
    if (_isVisible && !_isDragging) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() => _isVisible = false);
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    _animationController.dispose();
    super.dispose();
  }

  double _posToProgress(Offset localOffset, double height) {
    final availableHeight = height - _circleSize;
    final y = (localOffset.dy - _circleSize / 2).clamp(0.0, availableHeight);
    return (availableHeight <= 0) ? 0.0 : (y / availableHeight);
  }

  int _progressToPage(double progress) {
    final c = _pageCount ?? 1;
    final page = (progress * (c - 1)).round() + 1;
    return page.clamp(1, math.max(1, c));
  }

  // Real-time smooth scrolling to page
  void _scrollToPage(int pageNumber) {
    if (widget.controller.isReady && pageNumber >= 1 && pageNumber <= (_pageCount ?? 1)) {
      // Use goToPage for immediate navigation
      widget.controller.goToPage(pageNumber: pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible && !_isDragging) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final circleTop = (height - _circleSize) * _dragProgress;
        final currentPageDisplay = _currentPage ?? 1;
        final totalPages = _pageCount ?? 1;
        
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    // Page indicator container
                    Positioned(
                      top: circleTop + (_circleSize - 32) / 2,
                      right: _circleSize * 0.6, // Position to the left of the circle
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[800],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          constraints: const BoxConstraints(minWidth: 60),
                          child: Text(
                            '$currentPageDisplay / $totalPages',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Circular handle (partially hidden on the right)
                    Positioned(
                      top: circleTop,
                      right: -_circleSize * 0.3, // Partially hide the circle
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: (_) {
                          setState(() => _isDragging = true);
                          _showScrollbar();
                        },
                        onVerticalDragUpdate: (details) {
                          final newProgress = _posToProgress(details.localPosition, height);
                          setState(() {
                            _dragProgress = newProgress;
                          });
                          
                          // Real-time scrolling during drag
                          final targetPage = _progressToPage(_dragProgress);
                          _scrollToPage(targetPage);
                        },
                        onVerticalDragEnd: (_) {
                          setState(() => _isDragging = false);
                          
                          // Ensure we're on the correct page after drag ends
                          final finalPage = _progressToPage(_dragProgress);
                          _scrollToPage(finalPage);
                          
                          // Auto-hide after drag ends
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) _hideScrollbar();
                          });
                        },
                        onTap: () {
                          _showScrollbar();
                        },
                        child: Container(
                          width: _circleSize,
                          height: _circleSize,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(-2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.drag_indicator,
                              color: Colors.white70,
                              size: _circleSize * 0.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                 
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}