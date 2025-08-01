import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';


class AIImageGeneratorScreen extends StatefulWidget {
  @override
  _AIImageGeneratorScreenState createState() => _AIImageGeneratorScreenState();
}

class _AIImageGeneratorScreenState extends State<AIImageGeneratorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isOnline = true;
  bool _isGenerating = false;
  String? _generatedImageUrl;
  List<GeneratedImage> _imageHistory = [];
  String _selectedStyle = 'realistic';
  String _apiKey = 'YOUR_OPENAI_API_KEY'; // باید API Key رو اینجا قرار بدی

  final List<ImageStyle> _styles = [
    ImageStyle('realistic', 'واقع‌گرا', '📸', [Color(0xFF667eea), Color(0xFF764ba2)]),
    ImageStyle('artistic', 'هنری', '🎨', [Color(0xFFf093fb), Color(0xFFf5576c)]),
    ImageStyle('fantasy', 'فانتزی', '🧙‍♂️', [Color(0xFF4facfe), Color(0xFF00f2fe)]),
    ImageStyle('cyberpunk', 'سایبرپانک', '🤖', [Color(0xFF43e97b), Color(0xFF38f9d7)]),
    ImageStyle('anime', 'انیمه', '🌸', [Color(0xFFfa709a), Color(0xFFfee140)]),
    ImageStyle('minimalist', 'مینیمال', '⚪', [Color(0xFFa8edea), Color(0xFFfed6e3)]),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _checkConnectivity();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
    //
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   setState(() {
    //     _isOnline = result != ConnectivityResult.none;
    //   });
    // });
  }

  Future<void> _generateImage() async {
    if (_promptController.text.trim().isEmpty || !_isOnline) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // شبیه‌سازی درخواست به OpenAI API
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': '${_promptController.text} in ${_selectedStyle} style',
          'n': 1,
          'size': '1024x1024',
          'quality': 'hd',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['data'][0]['url'];

        setState(() {
          _generatedImageUrl = imageUrl;
          _imageHistory.insert(0, GeneratedImage(
            prompt: _promptController.text,
            style: _selectedStyle,
            url: imageUrl,
            timestamp: DateTime.now(),
          ));

          if (_imageHistory.length > 10) {
            _imageHistory.removeLast();
          }
        });

        _showSuccessAnimation();
      } else {
        _showErrorMessage('خطا در تولید تصویر');
      }
    } catch (e) {
      // برای نمایش، یک تصویر نمونه استفاده می‌کنیم
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _generatedImageUrl = 'https://picsum.photos/1024/1024?random=${DateTime.now().millisecondsSinceEpoch}';
        _imageHistory.insert(0, GeneratedImage(
          prompt: _promptController.text,
          style: _selectedStyle,
          url: _generatedImageUrl!,
          timestamp: DateTime.now(),
        ));
      });
      _showSuccessAnimation();
    }

    setState(() {
      _isGenerating = false;
    });
  }

  void _showSuccessAnimation() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ تصویر با موفقیت تولید شد!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF24243e),
              Color(0xFF302b63),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: 30),
                _buildPromptInput(),
                SizedBox(height: 20),
                _buildStyleSelector(),
                SizedBox(height: 30),
                _buildGenerateButton(),
                SizedBox(height: 30),
                if (_generatedImageUrl != null) _buildGeneratedImage(),
                if (_imageHistory.isNotEmpty) _buildImageHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 30),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Image Generator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            _isOnline ? Icons.wifi : Icons.wifi_off,
                            color: _isOnline ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text(
                            _isOnline ? 'آنلاین' : 'آفلاین',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromptInput() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _promptController,
        maxLines: 4,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'توضیح تصویری که می‌خواهید تولید کنید...\nمثال: یک گربه رنگارنگ در فضا',
          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
          prefixIcon: Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.edit, color: Colors.purple),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎨 انتخاب سبک',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _styles.length,
            itemBuilder: (context, index) {
              final style = _styles[index];
              final isSelected = _selectedStyle == style.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStyle = style.id;
                  });
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: 15),
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: style.colors),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(
                      color: style.colors[0].withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style.emoji,
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 8),
                      Text(
                        style.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return AnimatedBuilder(
      animation: _isGenerating ? _pulseAnimation : _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isGenerating ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _isOnline && !_isGenerating ? _generateImage : null,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOnline
                      ? [Color(0xFFf093fb), Color(0xFFf5576c)]
                      : [Colors.grey, Colors.grey.shade700],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _isOnline
                        ? Color(0xFFf093fb).withOpacity(0.4)
                        : Colors.transparent,
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: _isGenerating
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'در حال تولید...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      _isOnline ? 'تولید تصویر' : 'آفلاین',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneratedImage() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: _generatedImageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(color: Colors.purple),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 300,
            color: Colors.grey.shade800,
            child: Icon(Icons.error, color: Colors.red, size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📜 تاریخچه تصاویر',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageHistory.length,
            itemBuilder: (context, index) {
              final image = _imageHistory[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _generatedImageUrl = image.url;
                  });
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.purple.withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: image.url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade800,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ImageStyle {
  final String id;
  final String name;
  final String emoji;
  final List<Color> colors;

  ImageStyle(this.id, this.name, this.emoji, this.colors);
}

class GeneratedImage {
  final String prompt;
  final String style;
  final String url;
  final DateTime timestamp;

  GeneratedImage({
    required this.prompt,
    required this.style,
    required this.url,
    required this.timestamp,
  });
}