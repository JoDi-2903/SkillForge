import 'package:flutter/material.dart';
import 'package:local_captcha/local_captcha.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/screens/youtube_player_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = LocalCaptchaController();
  final _captchaTextController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
          'Anmelden',
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
                        labelText: 'Benutzername',
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
                          return 'Bitte geben Sie einen Benutzernamen ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
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
                          return 'Bitte geben Sie ein Passwort ein';
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
                                labelText: 'Captcha eingeben',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: AppColorScheme.indigo),
                                  onPressed: () => _captchaController.refresh(),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bitte geben Sie den Captcha-Code ein';
                                }
                                // Korrigierte Validierung
                                final validation =
                                    _captchaController.validate(value);
                                if (validation !=
                                    LocalCaptchaValidation.valid) {
                                  return 'Ungültiger Captcha-Code';
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
                          'Angemeldet bleiben',
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login erfolgreich')),
                          );
                        }
                      },
                      child: const Text('Anmelden'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const YoutubePlayerScreen()),
                        );
                      },
                      child: Text(
                        'Passwort vergessen?',
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
