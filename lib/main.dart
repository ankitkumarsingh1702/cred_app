// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/stack_bloc.dart';
import 'blocs/stack_event.dart';
import 'repositories/stack_repository.dart';
import 'screens/stack_screen.dart';
import 'utils/api_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final StackRepository repository = StackRepository(apiClient: ApiClient());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Figtree-Regular', // Apply custom font
      ),
      home: RepositoryProvider.value(
        value: repository,
        child: BlocProvider(
          create: (context) =>
          StackBloc(repository: repository)..add(FetchStackItems()),
          child: StackScreen(),
        ),
      ),
    );
  }
}
