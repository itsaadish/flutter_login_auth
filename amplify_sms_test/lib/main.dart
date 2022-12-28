import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'amplifyconfiguration.dart';

import 'outlinedautomatedtextfield.dart';

void main() {
  runApp(MaterialApp(home: SignInScreen()));
}

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _passwordController;
  late final TextEditingController _activationCodeController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _activationCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _activationCodeController.dispose();
    super.dispose();
  }

  Future<void> _configureAmplify() async {
    final auth = AmplifyAuthCognito();

    // Use addPlugins method to add more than one Amplify plugins
    await Amplify.addPlugin(auth);

    await Amplify.configure(amplifyconfig);
  }

  Future<void> _signInUser(
    String phoneNumber,
    String password,
  ) async {
    final result = await Amplify.Auth.signIn(
      username: phoneNumber,
      password: password,
    );
    if (result.isSignedIn) {
      debugPrint('Sign in is done.');
    } else {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm the user'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Check your phone number and enter the code below'),
              OutlinedAutomatedNextFocusableTextFormField(
                controller: _activationCodeController,
                padding: const EdgeInsets.only(top: 16),
                labelText: 'Activation Code',
                inputType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Amplify.Auth.confirmSignIn(
                  confirmationValue: _activationCodeController.text,
                ).then((result) {
                  if (result.isSignedIn) {
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amplify SMS Flow'),
      ),
      body: FutureBuilder<void>(
          future: _configureAmplify(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  OutlinedAutomatedNextFocusableTextFormField(
                    controller: _phoneNumberController,
                    labelText: 'Phone Number',
                    inputType: TextInputType.phone,
                  ),
                  OutlinedAutomatedNextFocusableTextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    labelText: 'Password',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final phoneNumber = _phoneNumberController.text;
                        final password = _passwordController.text;
                        if (phoneNumber.isEmpty || password.isEmpty) {
                          debugPrint(
                              'One of the fields is empty. Not ready to submit.');
                        } else {
                          _signInUser(phoneNumber, password);
                        }
                      },
                      child: const Text('Sign in'),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return Text('Some error happened: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
