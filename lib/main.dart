import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:u_app_utils/u_app_utils.dart';

import 'app/constants/strings.dart';
import 'app/data/database.dart';
import 'app/pages/landing/landing_page.dart';
import 'app/repositories/app_repository.dart';
import 'app/repositories/debts_repository.dart';
import 'app/repositories/locations_repository.dart';
import 'app/repositories/orders_repository.dart';
import 'app/repositories/partners_repository.dart';
import 'app/repositories/points_repository.dart';
import 'app/repositories/prices_repository.dart';
import 'app/repositories/return_acts_repository.dart';
import 'app/repositories/shipments_repository.dart';
import 'app/repositories/users_repository.dart';
import 'app/repositories/visits_repository.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await PackageInfo.fromPlatform();

  bool isDebug = Misc.isDebug();
  RenewApi api = await RenewApi.init(appName: Strings.appName, url: const String.fromEnvironment('PALMAN_RENEW_URL'));
  AppDataStore dataStore = AppDataStore(logStatements: isDebug);
  AppRepository appRepository = AppRepository(dataStore, api);

  DebtsRepository debtsRepository = DebtsRepository(dataStore, api);
  LocationsRepository locationsRepository = LocationsRepository(dataStore, api);
  OrdersRepository ordersRepository = OrdersRepository(dataStore, api);
  PartnersRepository partnersRepository = PartnersRepository(dataStore, api);
  PointsRepository pointsRepository = PointsRepository(dataStore, api);
  PricesRepository pricesRepository = PricesRepository(dataStore, api);
  ReturnActsRepository returnActsRepository = ReturnActsRepository(dataStore, api);
  ShipmentsRepository shipmentsRepository = ShipmentsRepository(dataStore, api);
  UsersRepository usersRepository = UsersRepository(dataStore, api);
  VisitsRepository visitsRepository = VisitsRepository(dataStore, api);

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  FlutterError.onError = (errorDetails) {
    Misc.logError(errorDetails.exception, errorDetails.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Misc.logError(error, stack);
    return true;
  };

  await Initialization.initializeSentry(
    dsn: const String.fromEnvironment('PALMAN_SENTRY_DSN'),
    isDebug: isDebug,
    userGenerator: () async {
      User user = await usersRepository.getCurrentUser();

      return SentryUser(id: user.id.toString(), username: user.username, email: user.email);
    },
    appRunner: () => runApp(
      MultiRepositoryProvider(
        providers: [
          Provider.value(value: scaffoldMessengerKey),
          RepositoryProvider.value(value: appRepository),
          RepositoryProvider.value(value: debtsRepository),
          RepositoryProvider.value(value: ordersRepository),
          RepositoryProvider.value(value: locationsRepository),
          RepositoryProvider.value(value: partnersRepository),
          RepositoryProvider.value(value: pointsRepository),
          RepositoryProvider.value(value: pricesRepository),
          RepositoryProvider.value(value: returnActsRepository),
          RepositoryProvider.value(value: shipmentsRepository),
          RepositoryProvider.value(value: usersRepository),
          RepositoryProvider.value(value: visitsRepository)
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: Strings.ruAppName,
          theme: FlexThemeData.light(
            useMaterial3: false,
            scheme: FlexScheme.hippieBlue,
            subThemesData: const FlexSubThemesData(
              inputDecoratorBorderType: FlexInputBorderType.underline,
              inputDecoratorFocusedBorderWidth: 0,
              inputDecoratorBackgroundAlpha: 0,
              inputDecoratorFillColor: Colors.transparent,
              bottomSheetRadius: 0
            ),
            platform: TargetPlatform.android,
            visualDensity: VisualDensity.adaptivePlatformDensity
          ),
          home: LandingPage(),
          locale: const Locale('ru', 'RU'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ]
        )
      )
    )
  );
}
