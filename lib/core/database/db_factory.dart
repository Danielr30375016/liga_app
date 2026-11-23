// Si la app corre en web, usa el archivo web; si no, el de móvil.
export 'db_factory_mobile.dart'
    if (dart.library.js_interop) 'db_factory_web.dart';
