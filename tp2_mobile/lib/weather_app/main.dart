import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_cubit.dart';
import 'weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(),
      child: MaterialApp(
        title: 'Application Météo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home:  WeatherPage(),
      ),
    );
  }
}
