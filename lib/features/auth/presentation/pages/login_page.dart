import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_field.dart';
import 'package:routepractice/features/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override 
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Log In", style: TextStyle(fontSize: 50, fontWeight:FontWeight.bold),),
              const SizedBox(height: 30,),
              AuthField(hintText: 'Email', controller: emailController,),
              const SizedBox(height: 15,),
              AuthField(hintText: 'Password', controller: passwordController, isObscureText: true,),
              const SizedBox(height: 15,),
              AuthGradientButton(
                text: "Log In", 
                nameController: TextEditingController(), 
                emailController: emailController, 
                passwordController: passwordController,
                isLogin: true,
                
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(onPressed:() => {context.go('/signup')}, 
                  child: Text("Sign In", style: TextStyle(color: AppPalette.accent ),))
                ],
              )
              
            ],
          ),
        ),
      ),
    );
  }
}