import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_captcha/local_captcha.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/screens/video_player_screen.dart';
import 'package:skill_forge/main.dart';
import 'package:skill_forge/utils/languages.dart';

// Global user state management
class UserState {
  static final UserState _instance = UserState._internal();
  factory UserState() => _instance;
  UserState._internal();

  int? userId;
  String? username;
  bool? isAdmin;

  Future<void> saveUserData(int userId, String username, bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('username', username);
    await prefs.setBool('isAdmin', isAdmin);

    this.userId = userId;
    this.username = username;
    this.isAdmin = isAdmin;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    username = prefs.getString('username');
    isAdmin = prefs.getBool('isAdmin');
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('isAdmin');

    userId = null;
    username = null;
    isAdmin = null;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = LocalCaptchaController();
  final _captchaTextController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Perform login API call
  Future _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate captcha
    final captchaValidation =
        _captchaController.validate(_captchaTextController.text);
    if (captchaValidation != LocalCaptchaValidation.valid) {
      setState(() {
        _captchaController.refresh();
        _captchaTextController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.wrongCaptcha)),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password_hash': _hashPassword(_passwordController.text),
        }),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        // Save user data globally
        await UserState().saveUserData(
          responseData['user_id'],
          _usernameController.text,
          responseData['is_admin'],
        );

        // Navigate to home screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(title: AppStrings.hompageTitle)));
      } else {
        // Refresh captcha and clear captcha text field on failed login
        setState(() {
          _captchaController.refresh();
          _captchaTextController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? AppStrings.failedLogin),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Refresh captcha and clear captcha text field on network error
      setState(() {
        _captchaController.refresh();
        _captchaTextController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.networkError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _captchaTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Existing UI code remains the same, just update the onPressed for login button
    return Scaffold(
      backgroundColor: AppColorScheme.ownWhite,
      appBar: AppBar(
        backgroundColor: AppColorScheme.antiFlash,
        elevation: 5,
        shadowColor: AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppStrings.login,
          style: TextStyle(color: AppColorScheme.ownBlack),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorScheme.indigo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: AppColorScheme.indigo,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.username,
                        prefixIcon:
                            Icon(Icons.person, color: AppColorScheme.indigo),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.insertUsername;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        prefixIcon:
                            Icon(Icons.lock, color: AppColorScheme.indigo),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColorScheme.indigo,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.insertPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColorScheme.slate),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          LocalCaptcha(
                            key: ValueKey('captcha'),
                            controller: _captchaController,
                            height: 150,
                            width: 300,
                            backgroundColor: AppColorScheme.ownWhite,
                            chars: 'abdefghnryABDEFGHNQRY3468',
                            length: 5,
                            fontSize: 30,
                            textColors: [AppColorScheme.indigo],
                            noiseColors: [AppColorScheme.slate],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _captchaTextController,
                              decoration: InputDecoration(
                                labelText: AppStrings.captcha,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: AppColorScheme.indigo),
                                  onPressed: () => _captchaController.refresh(),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.insertCaptcha;
                                }
                                // Korrigierte Validierung
                                final validation =
                                    _captchaController.validate(value);
                                if (validation !=
                                    LocalCaptchaValidation.valid) {
                                  return AppStrings.wrongCaptcha;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColorScheme.indigo,
                        ),
                        Text(
                          AppStrings.rememberMe,
                          style: TextStyle(color: AppColorScheme.ownBlack),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorScheme.indigo,
                        foregroundColor: AppColorScheme.ownWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _performLogin,
                      child: Text(AppStrings.login),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VideoPlayerScreen()),
                        );
                      },
                      child: Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(color: AppColorScheme.indigo),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
