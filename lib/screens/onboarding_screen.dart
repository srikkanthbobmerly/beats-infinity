import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';

// ---------------------------------------------------------------------------
// Slide content model
// ---------------------------------------------------------------------------

class _Feature {
  final IconData icon;
  final String text;
  const _Feature(this.icon, this.text);
}

class _SlideData {
  final String? badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient bgGradient;
  final Gradient iconGradient;
  final List<_Feature>? features;

  const _SlideData({
    this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgGradient,
    required this.iconGradient,
    this.features,
  });
}

final _slides = [
  // 1. Hero / brand intro
  _SlideData(
    title: 'Beats Infinity',
    subtitle: 'Where every month is a brand new stage —\nand somebody\'s about to become your duet partner.',
    icon: Icons.graphic_eq_rounded,
    bgGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B1120), Color(0xFF1B1440), Color(0xFF2A1B4D)],
    ),
    iconGradient: gradientPrimary,
  ),
  // 2. For singers
  _SlideData(
    badge: 'FOR SINGERS',
    title: 'Take The Stage',
    subtitle: 'Everything you need as a performer, in one place.',
    icon: Icons.mic_external_on_rounded,
    bgGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B1120), Color(0xFF0E2E38), Color(0xFF123A3F)],
    ),
    iconGradient: const LinearGradient(colors: [AppColors.teal, AppColors.primary]),
    features: const [
      _Feature(Icons.celebration_rounded, 'See this month\'s theme the second it drops'),
      _Feature(Icons.library_music_rounded, 'Submit your song & browse the full lineup'),
      _Feature(Icons.headphones_rounded, 'Get paired and grab your karaoke track'),
    ],
  ),
  // 3. For admins
  _SlideData(
    badge: 'FOR ADMINS',
    title: 'Run The Show',
    subtitle: 'Full control over every event — zero spreadsheets.',
    icon: Icons.dashboard_customize_rounded,
    bgGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B1120), Color(0xFF3A2410), Color(0xFF44210F)],
    ),
    iconGradient: gradientWarm,
    features: const [
      _Feature(Icons.campaign_rounded, 'Announce the theme & submission deadline'),
      _Feature(Icons.auto_awesome_rounded, 'Auto-pair every singer with one tap'),
      _Feature(Icons.link_rounded, 'Assign karaoke tracks to every duet'),
    ],
  ),
  // 4. Final CTA
  _SlideData(
    title: 'Ready To Sing?',
    subtitle: 'Your next duet partner is already\nwaiting to find out you exist.',
    icon: Icons.favorite_rounded,
    bgGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B1120), Color(0xFF3D1230), Color(0xFF4A1440)],
    ),
    iconGradient: const LinearGradient(colors: [AppColors.pink, AppColors.accent]),
  ),
];

// ---------------------------------------------------------------------------
// Onboarding screen
// ---------------------------------------------------------------------------

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _slides.length - 1;

  void _next() {
    if (_isLast) {
      _goToLogin();
      return;
    }
    _controller.nextPage(duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, anim, __) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_page];

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient backdrop, unique per slide
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(gradient: slide.bgGradient),
            width: double.infinity,
            height: double.infinity,
          ),
          // Decorative glow blobs for depth
          Positioned(
            top: -60,
            right: -40,
            child: _Glow(color: slide.iconGradient.colors.first, size: 220),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: _Glow(color: slide.iconGradient.colors.last, size: 260),
          ),
          SafeArea(
            child: Column(
              children: [
                if (!_isLast)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 12),
                      child: TextButton(
                        onPressed: _goToLogin,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.06),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 44), // keeps slide content vertically centered like the other pages
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (context, i) => _SlideView(key: ValueKey(i), slide: _slides[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 26 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          gradient: active ? gradientPrimary : null,
                          color: active ? null : Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: _GradientButton(
                    label: _isLast ? "Let's Go" : 'Next',
                    icon: _isLast ? Icons.mic_rounded : Icons.arrow_forward_rounded,
                    gradient: slide.iconGradient,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slide view with entrance animation
// ---------------------------------------------------------------------------

class _SlideView extends StatefulWidget {
  final _SlideData slide;
  const _SlideView({super.key, required this.slide});

  @override
  State<_SlideView> createState() => _SlideViewState();
}

class _SlideViewState extends State<_SlideView> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _slideUp = Tween(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _scale = Tween(begin: 0.82, end: 1.0).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutBack));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = widget.slide;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slideUp,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    gradient: slide.iconGradient,
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(color: slide.iconGradient.colors.first.withOpacity(0.5), blurRadius: 32, offset: const Offset(0, 14)),
                    ],
                  ),
                  child: Icon(slide.icon, color: Colors.white, size: 58),
                ),
              ),
              const SizedBox(height: 30),
              if (slide.badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    slide.badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.1),
              ),
              const SizedBox(height: 12),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14.5, height: 1.5),
              ),
              if (slide.features != null) ...[
                const SizedBox(height: 28),
                ...slide.features!.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: slide.iconGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(f.icon, color: Colors.white, size: 17),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(f.text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3)),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small reusable pieces
// ---------------------------------------------------------------------------

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.35), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: gradient.colors.first.withOpacity(0.45), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 19),
            ],
          ),
        ),
      ),
    );
  }
}
