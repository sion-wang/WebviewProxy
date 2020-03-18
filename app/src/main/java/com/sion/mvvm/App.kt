package com.sion.mvvm

import android.app.Application
import com.sion.mvvm.di.appModule
import com.sion.mvvm.di.apiModule
import com.sion.mvvm.di.managerModule
import com.sion.mvvm.di.viewModelModule
import com.sion.mvvm.model.pref.Pref
import com.facebook.stetho.Stetho
import com.sion.mvvm.widget.utility.ProxySettings
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import timber.log.Timber

class App : Application() {

    companion object {
        lateinit var self: Application
        var pref: Pref? = null
        fun applicationContext(): Application {
            return self
        }
    }

    init {
        self = this
    }

    override fun onCreate() {
        super.onCreate()

       if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
            Stetho.initializeWithDefaults(this)
        }

//        val result = ProxySettings.setProxy(this, "prod-video-proxy-tw-01-private.prod.silkrode.com.tw", 8888)
        val result = ProxySettings.setProxy(this, "127.0.0.1", 8080)
        Timber.d("setProxy result: $result")

        val module = listOf(
                appModule,
                apiModule,
                managerModule,
                viewModelModule
        )

        startKoin {
            androidLogger()
            androidContext(this@App)
            modules(module)
        }
    }
}