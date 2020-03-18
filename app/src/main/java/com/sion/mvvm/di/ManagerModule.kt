package com.sion.mvvm.di

import com.sion.mvvm.model.manager.AccountManager
import com.sion.mvvm.model.manager.DeviceManager
import com.sion.mvvm.model.manager.DomainManager
import com.sion.mvvm.model.pref.Pref
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
