package org.younact.palman

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setLocale("ru_RU")
    MapKitFactory.setApiKey(BuildConfig.PALMAN_YANDEX_API_KEY)
  }
}
