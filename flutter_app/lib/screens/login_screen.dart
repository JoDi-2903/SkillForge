import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
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
  bool isLoggedIn = false;

  Future<void> saveUserData(int userId, String username, bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('username', username);
    await prefs.setBool('isAdmin', isAdmin);

    this.userId = userId;
    this.username = username;
    this.isAdmin = isAdmin;
    isLoggedIn = true;
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

class CaptchaWidget extends StatefulWidget {
  final LocalCaptchaController controller;
  final TextEditingController textController;

  CaptchaWidget({required this.controller, required this.textController});

  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColorScheme.slate),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          LocalCaptcha(
            controller: widget.controller,
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
              controller: widget.textController,
              decoration: InputDecoration(
                labelText: AppStrings.captcha,
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh, color: AppColorScheme.indigo),
                  onPressed: () => widget.controller.refresh(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.insertCaptcha;
                }
                final validation = widget.controller.validate(value);
                if (validation != LocalCaptchaValidation.valid) {
                  return AppStrings.wrongCaptcha;
                }
                return null;
              },
              style: TextStyle(color: AppColorScheme.ownBlack),
            ),
          ),
        ],
      ),
    );
  }
}

// Secure storage for storing the JWT
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = LocalCaptchaController();
  final _captchaTextController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Hash password using Argon2
  Future<String> _hashPassword(String password) async {
    // Note: Use a new salt for each user in production
    final Salt salt = Salt(
        [12, 34, 56, 78, 90, 123, 234, 56, 78, 90, 12, 34, 56, 78, 90, 123]);

    // Use argon2 instance to call hashPasswordString
    final result = await argon2.hashPasswordString(password,
        salt: salt,
        type: Argon2Type.id,
        iterations: 32,
        memory: 19 * 1024,
        parallelism: 1,
        length: 32);

    // Return the encoded hash
    return result.encodedString;
  }

  // Perform login API call
  Future _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate captcha first
    final captchaValidation =
        _captchaController.validate(_captchaTextController.text);
    if (captchaValidation != LocalCaptchaValidation.valid) {
      setState(() {
        _isLoading = true;
        _captchaController.refresh();
        _captchaTextController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.wrongCaptcha)),
      );
      return;
    }

    try {
      // Hash password using Argon2
      final passwordHash = await _hashPassword(_passwordController.text);
      print(
          'Password Hash for debugging: $passwordHash'); // Remove in production

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password_hash': passwordHash,
        }),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['success'] && response.statusCode == 200) {
        final String token = responseData['token'];

        // Store the token securely
        await secureStorage.write(key: 'jwt_token', value: token);

        // Show success message
        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevent user from dismissing dialog by tapping outside
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(); // Close the dialog after 2 seconds
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: AppStrings.hompageTitle),
                ),
              );
            });

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorScheme.ownWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${AppStrings.loginSuccessful} ${_usernameController.text}!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, color: AppColorScheme.ownBlack),
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
        centerTitle: true,
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
                    Image.asset(
                      'assets/img/skillforge_logo.png',
                      height: 128,
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
                      style: TextStyle(color: AppColorScheme.ownBlack),
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
                      style: TextStyle(color: AppColorScheme.ownBlack),
                    ),
                    const SizedBox(height: 16),
                    CaptchaWidget(
                      controller: _captchaController,
                      textController: _captchaTextController,
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
                      onPressed: _isLoading ? null : _performLogin,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: AppColorScheme.ownWhite)
                          : Text(
                              AppStrings.login,
                              style: TextStyle(
                                  fontSize: 18, color: AppColorScheme.ownWhite),
                            ),
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
