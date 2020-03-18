package {{.Project}}.di

import {{.Project}}.view.main.MainViewModel
import {{.Project}}.view.splash.SplashViewModel
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

val viewModelModule = module {
    viewModel { MainViewModel() }
    viewModel { SplashViewModel() }
}