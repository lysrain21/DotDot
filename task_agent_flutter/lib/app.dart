import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/task/task_bloc.dart';
import 'bloc/task/task_event.dart';
import 'navigation/app_router.dart';
import 'services/api_service.dart';
import 'theme/shadcn_theme.dart';

void main() {
  runApp(const TaskAgentApp());
}

class TaskAgentApp extends StatelessWidget {
  const TaskAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(apiService: ApiService())..add(LoadTasks()),
      child: MaterialApp(
        title: 'dotdot',
        theme: ShadcnTheme.lightTheme,
        darkTheme: ShadcnTheme.darkTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.taskInput,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}