import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'admin@krishnadairy.com');
    _passwordController = TextEditingController(text: 'admin123');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      if (email.contains('admin')) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  void _loginAsCustomer() {
    _emailController.text = 'customer@krishnadairy.com';
    _passwordController.text = 'customer123';
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _loginAsAdmin() {
    _emailController.text = 'admin@krishnadairy.com';
    _passwordController.text = 'admin123';
    Navigator.pushReplacementNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background Image with Overlay ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_hero_banner.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE8F5E9),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),

          // ── Scrollable Form content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // ── Circular Logo ──
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/krishna_logo.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.agriculture,
                            size: 70,
                            color: Color(0xFF0C3823),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── App Title ──
                    const Text(
                      'Krishna Dairy Farm',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ── App Subtitle ──
                    Text(
                      'Precision Herd Management',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Welcome Back Card ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Email/Username Label ──
                            const Text(
                              'Email or Username',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── Email TextField ──
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'manager@farm.com',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                                prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF6B7280), size: 20),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF0C3823), width: 1.5),
                                ),
                                errorStyle: const TextStyle(fontSize: 11),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email or username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // ── Password Label Row ──
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Forgot Password flow coming soon!')),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0C3823),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // ── Password TextField ──
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF6B7280), size: 20),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF6B7280),
                                    size: 20,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF0C3823), width: 1.5),
                                ),
                                errorStyle: const TextStyle(fontSize: 11),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // ── Remember Me Checkbox ──
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: const Color(0xFF0C3823),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Remember me on this device',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4B5563),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            // ── Log In Button ──
                             SizedBox(
                               width: double.infinity,
                               height: 48,
                               child: ElevatedButton.icon(
                                 onPressed: _handleLogin,
                                 icon: const Icon(Icons.login, color: Colors.white, size: 20),
                                 label: const Text(
                                   'Log In to App',
                                   style: TextStyle(
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: const Color(0xFF0C3823),
                                   foregroundColor: Colors.white,
                                   elevation: 1,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                 ),
                               ),
                             ),
                             const SizedBox(height: 12),

                             // ── Dedicated Portal Quick Launchers ──
                             Row(
                               children: [
                                 Expanded(
                                   child: OutlinedButton.icon(
                                     onPressed: _loginAsCustomer,
                                     icon: const Icon(Icons.shopping_bag_outlined, size: 16, color: Color(0xFF0C3823)),
                                     label: const Text(
                                       'Customer App',
                                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0C3823)),
                                     ),
                                     style: OutlinedButton.styleFrom(
                                       padding: const EdgeInsets.symmetric(vertical: 12),
                                       side: const BorderSide(color: Color(0xFF0C3823)),
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(width: 10),
                                 Expanded(
                                   child: ElevatedButton.icon(
                                     onPressed: _loginAsAdmin,
                                     icon: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                                     label: const Text(
                                       'Admin Portal',
                                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                     ),
                                     style: ElevatedButton.styleFrom(
                                       padding: const EdgeInsets.symmetric(vertical: 12),
                                       backgroundColor: const Color(0xFF14532D),
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                            const SizedBox(height: 20),

                            // ── Divider ──
                            const Row(
                              children: [
                                Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF9CA3AF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ── Create New Account Button ──
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  foregroundColor: const Color(0xFF1F2937),
                                  backgroundColor: const Color(0xFFF9FAFB),
                                ),
                                child: const Text(
                                  'Create New Account',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Under Card Links ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Forgot Password flow coming soon!')),
                            );
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Support contacts can be found in our profile menu!')),
                            );
                          },
                          child: const Text(
                            'Contact Support',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
