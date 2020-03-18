package com.sion.mvvm.di

import com.sion.mvvm.view.main.MainViewModel
import com.sion.mvvm.view.splash.SplashViewModel
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

val viewModelModule = module {
    viewModel { MainViewModel() }
    viewModel { SplashViewModel() }
}