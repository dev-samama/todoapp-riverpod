import 'package:flutter/material.dart';
import 'package:todotask/views/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: SplashView(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
