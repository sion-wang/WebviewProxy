package {{.Project}}

import android.app.Application
import {{.Project}}.di.appModule
import {{.Project}}.di.apiModule
import {{.Project}}.di.managerModule
import {{.Project}}.di.viewModelModule
import {{.Project}}.model.pref.Pref
import com.facebook.stetho.Stetho
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