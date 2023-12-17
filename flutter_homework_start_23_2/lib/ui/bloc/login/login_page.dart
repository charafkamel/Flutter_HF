import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/main.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});
  
  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
  super.initState();
  SchedulerBinding.instance!.addPostFrameCallback((_) {
    _init();
  });
}

void _init() async {
    BlocProvider.of<LoginBloc>(context).add(LoginAutoLoginEvent());
}



  @override
  Widget build(BuildContext context) {
    return 
      BlocConsumer<LoginBloc, LoginState>(
        
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          else if(state is LoginSuccess){
            Navigator.of(context).pushReplacementNamed('/list');
          }
        },
        
        builder: (context, state) {
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login Page'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      onChanged: (value) {
                          setState(() {
                            GetIt.I<EmailPass>().setEmail(null);
                          });
                        },
                      decoration: InputDecoration(
                        labelText: 'Email', 
                        errorText: state is LoginForm ? GetIt.I<EmailPass>().email : null,
                        
                      ),
                     
                      enabled: state is! LoginLoading,
                    ),
                    TextField(
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          GetIt.I<EmailPass>().setPass(null);
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: state is LoginForm ? GetIt.I<EmailPass>().pass : null,
                      ),
                     
                      enabled: state is! LoginLoading,
                    ),
                        CheckboxListTile(
                          value: rememberMe,
                          onChanged: state is LoginLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                          title: Text('Remember me'),
                        ),
         
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: state is! LoginLoading
                          ? () {
                              BlocProvider.of<LoginBloc>(context).add(LoginSubmitEvent(
                                emailController.text,
                                passwordController.text,
                                rememberMe,
                              ));
                            }
                          : null,
                      child: Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                   // if (state is LoginLoading)
                   //   CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
