import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/app_colors.dart';
import 'package:frontend/core/widgets/custom_toast.dart';
import 'package:frontend/core/widgets/text_field_custom.dart';
import 'package:frontend/logic/bloc/auth/auth_bloc.dart';
import 'package:frontend/logic/bloc/auth/auth_event.dart';
import 'package:frontend/logic/bloc/auth/auth_state.dart';
import 'package:frontend/ui/pages/auth/register_page.dart';
import 'package:frontend/ui/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // bool _isObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            bool isUserAdmin =
                _usernameController.text.toLowerCase() == 'admin';
            CustomToast.show(context, "Login berhasil!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(isAdmin: isUserAdmin),
              ),
            );
          } else if (state is AuthError) {
            CustomToast.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          return Container(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey, // Masukkan key-nya di sini
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'Silakan masuk ke akun Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 48),

                      TextFieldCustomWidget(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person_2_outlined,
                        // keyboardType: TextInputType.emailAddress,
                        // Di sinilah tempat naruh validasinya!
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFieldCustomWidget(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true, // Otomatis jalanin mode password!
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null; // AMAN
                        },
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () {
                          // 4. Tombol pencet -> Jalankan validasi!
                          if (_formKey.currentState!.validate()) {
                            // Kalau masuk sini, artinya semua form sudah terisi dengan benar (return null).
                            // Tinggal lempar datanya ke AuthBloc deh!

                            context.read<AuthBloc>().add(
                              LoginRequested(
                                username: _usernameController
                                    .text, // Sesuaikan dengan API
                                password: _passwordController.text,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data...'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum punya akun? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              "Daftar di sini",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
