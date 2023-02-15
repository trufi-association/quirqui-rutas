import 'package:flutter/material.dart';
import 'package:quirqui_rutas/custom_async_executor.dart';
import 'package:quirqui_rutas/values.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/models/trufi_latlng.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';
import 'package:trufi_core/base/utils/graphql_client/hive_init.dart';
import 'package:trufi_core/base/widgets/screen/lifecycle_reactor_notification.dart';
import 'package:trufi_core/trufi_core.dart';
import 'package:trufi_core/trufi_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatedLetsencryptAndroid.workAroundCertificated();
  await initHiveForFlutter();
  runApp(
    TrufiApp(
      appNameTitle: 'Quirqui rutas',
      trufiLocalization: DefaultValues.trufiLocalization(
        currentLocale: const Locale("es"),
      ),
      blocProviders: [
        ...DefaultValues.blocProviders(
          otpEndpoint: "https://api.quirquirutas.com/otp",
          otpGraphqlEndpoint: "https://api.quirquirutas.com/otp/index/graphql",
          mapConfiguration: MapConfiguration(
            center: const TrufiLatLng(-17.970346, -67.114352),
          ),
          searchAssetPath: "assets/data/search.json",
          photonUrl: "https://api.quirquirutas.com/photon",
          mapTileProviders: [
            OSMMapLayer(
              mapTilesUrl:
                  "https://api.quirquirutas.com/static-maps/basic/{z}/{x}/{y}@2x.jpg",
            )
          ],
        ),
      ],
      trufiRouter: TrufiRouter(
        routerDelegate: DefaultValues.routerDelegate(
          appName: 'Quirqui rutas',
          cityName: 'Oruro',
          countryName: 'Bolivia',
          backgroundImageBuilder: (_) {
            return Image.asset(
              'assets/images/drawer-bg.jpg',
              fit: BoxFit.cover,
            );
          },
          emailContact: 'feedback@trufi.app',
          urlShareApp: 'https://quirquirutas.com',
          shareBaseUri: Uri(
            scheme: "https",
            host: "api.quirquirutas.com",
          ),
          lifecycleReactorHandler: LifecycleReactorNotifications(
            url:
                'https://api.quirquirutas.com/static_files/notification.json',
          ),
          asyncExecutor: customAsyncExecutor,
        ),
      ),
    ),
  );
}
