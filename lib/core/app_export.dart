import 'package:flutter/material.dart';

export 'package:app_links/app_links.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:carousel_slider_plus/carousel_slider_plus.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:dio/dio.dart';
export 'package:easy_date_timeline/easy_date_timeline.dart';
export 'package:file_picker/file_picker.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_crashlytics/firebase_crashlytics.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:flutter/foundation.dart' hide Category;
export 'package:flutter/services.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
export 'package:flutter_rating_bar/flutter_rating_bar.dart';
export 'package:flutter_stripe/flutter_stripe.dart' hide RowStyle;
export 'package:flutter_switch/flutter_switch.dart';
export 'package:geolocator/geolocator.dart' hide ServiceStatus;
export 'package:get/get.dart' hide FormData, Response, MultipartFile; //Trans,
export 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
export 'package:google_mlkit_translation/google_mlkit_translation.dart';
export 'package:googleapis_auth/googleapis_auth.dart'
    hide ResponseType, AccessToken;
export 'package:hive_ce/hive.dart';
export 'package:hive_ce_flutter/hive_flutter.dart';
export 'package:image_picker/image_picker.dart';
export 'package:intl/date_symbol_data_local.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:latlong2/latlong.dart';
export 'package:nominatim_flutter/nominatim_flutter.dart';
export 'package:path_provider/path_provider.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:pin_code_fields/pin_code_fields.dart';
export 'package:responsive_grid_list/responsive_grid_list.dart';
export 'package:searchfield/searchfield.dart';
export 'package:smooth_page_indicator/smooth_page_indicator.dart';
export 'package:url_launcher/url_launcher.dart';

/// Core
export '/core/bindings/export.dart';
export '/core/controllers/export.dart';
export '/core/models/export.dart';
export '/core/network/export.dart';
export '/core/services/export.dart';
export '/core/utils/export.dart';

///
export '/localization/app_localization.dart';
export '/presentation/export.dart';
export '/routes/app_routes.dart';
export '/theme/export.dart';
export '/widgets/export.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
