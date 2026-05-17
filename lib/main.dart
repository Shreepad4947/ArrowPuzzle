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

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final storageService = StorageService();
  await storageService.init();

  final levelRepository = LevelRepository();
  final userRepository = UserRepository(storageService: storageService);
  final gameRepository = GameRepository(
    levelRepository: levelRepository,
    userRepository: userRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storageService),
        Provider.value(value: levelRepository),
        Provider.value(value: userRepository),
        Provider.value(value: gameRepository),
        ChangeNotifierProvider(
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
