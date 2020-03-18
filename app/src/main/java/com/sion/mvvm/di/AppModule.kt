package com.sion.mvvm.di

import com.sion.mvvm.Constant
import com.sion.mvvm.model.pref.Pref
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import org.koin.dsl.module

val appModule = module {
    single { provideGson() }
    single { providePref(get()) }
}

fun provideGson(): Gson {
    return GsonBuilder().create()
}

fun providePref(gson: Gson): Pref {
    return Pref(gson, Constant.PREFS_NAME)
}