import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/level_repository.dart';
import 'data/repositories/game_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/storage_service.dart';
import 'game_engine/game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize storage
  final storageService = StorageService();
  await storageService.init();

  // Initialize repositories
  final levelRepository = LevelRepository();
  final userRepository = UserRepository(storageService: storageService);
  final gameRepository = GameRepository(
    levelRepository: levelRepository,
    userRepository: userRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<LevelRepository>.value(value: levelRepository),
        Provider<UserRepository>.value(value: userRepository),
        Provider<GameRepository>.value(value: gameRepository),
        ChangeNotifierProvider<GameController>(
          create: (_) => GameController(
            gameRepository: gameRepository,
            userRepository: userRepository,
          ),
        ),
      ],
      child: const ArrowMazeApp(),
    ),
  );
}