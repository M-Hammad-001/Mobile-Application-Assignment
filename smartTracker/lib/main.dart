import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/location_service.dart';
import 'services/camera_service.dart';
import 'repositories/activity_repository.dart';
import 'providers/activity_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        Provider<CameraService>(
          create: (_) => CameraService(),
        ),

        // Repository
        ProxyProvider4<ApiService, StorageService, LocationService, CameraService, ActivityRepository>(
          update: (_, apiService, storageService, locationService, cameraService, __) =>
              ActivityRepository(
                apiService: apiService,
                storageService: storageService,
              ),
        ),

        // Provider (State Management)
        ChangeNotifierProxyProvider3<ActivityRepository, LocationService, CameraService, ActivityProvider>(
          create: (context) => ActivityProvider(
            repository: context.read<ActivityRepository>(),
            locationService: context.read<LocationService>(),
            cameraService: context.read<CameraService>(),
          ),
          update: (_, repository, locationService, cameraService, previous) =>
          previous ??
              ActivityProvider(
                repository: repository,
                locationService: locationService,
                cameraService: cameraService,
              ),
        ),
      ],
      child: MaterialApp(
        title: 'SmartTracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}