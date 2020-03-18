package {{.Project}}.di

import {{.Project}}.model.manager.AccountManager
import {{.Project}}.model.manager.DeviceManager
import {{.Project}}.model.manager.DomainManager
import {{.Project}}.model.pref.Pref
import okhttp3.OkHttpClient
import org.koin.dsl.module

val managerModule = module {
    single { provideDomainManager(get()) }
    single { provideAccountManager(get(), get()) }
    single { provideDeviceManager(get()) }
}

fun provideDomainManager(okHttpClient: OkHttpClient): DomainManager {
    return DomainManager(okHttpClient)
}

fun provideAccountManager(pref: Pref,
                          domainManager: DomainManager): AccountManager {
    return AccountManager(pref, domainManager)
}

fun provideDeviceManager(domainManager: DomainManager): DeviceManager {
    return DeviceManager(domainManager)
}
