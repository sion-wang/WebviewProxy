package {{.Project}}.di

import {{.Project}}.BuildConfig
import {{.Project}}.Constant
import {{.Project}}.model.api.ApiLogInterceptor
import {{.Project}}.model.api.ApiService
import {{.Project}}.model.api.AuthInterceptor
import {{.Project}}.model.pref.Pref
import com.facebook.stetho.okhttp3.StethoInterceptor
import com.google.gson.Gson
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

val apiModule = module {
    single { provideAuthInterceptor(get()) }
    single { provideHttpLoggingInterceptor() }
    single { provideOkHttpClient(get(), get(), get()) }
    single { provideApiService(get()) }
    single { provideApiLogInterceptor() }
}

fun provideAuthInterceptor(pref: Pref): AuthInterceptor {
    return AuthInterceptor(pref)
}

fun provideApiLogInterceptor(): ApiLogInterceptor {
    return ApiLogInterceptor()
}

fun provideHttpLoggingInterceptor(): HttpLoggingInterceptor {
    val httpLoggingInterceptor = HttpLoggingInterceptor()
    httpLoggingInterceptor.level = when (BuildConfig.DEBUG) {
        true -> HttpLoggingInterceptor.Level.BODY
        else -> HttpLoggingInterceptor.Level.NONE
    }
    return httpLoggingInterceptor
}

fun provideOkHttpClient(
        authInterceptor: AuthInterceptor,
        httpLoggingInterceptor: HttpLoggingInterceptor,
        apiLogInterceptor: ApiLogInterceptor
): OkHttpClient {
    val builder = OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(60, TimeUnit.SECONDS)
            .addInterceptor(authInterceptor)
            .addInterceptor(apiLogInterceptor)
            .addInterceptor(httpLoggingInterceptor)

    when {
        BuildConfig.DEBUG -> {
            builder.addNetworkInterceptor(StethoInterceptor())
        }
        else -> {}
    }

    return builder.build()
}

fun provideApiService(okHttpClient: OkHttpClient): ApiService {
    return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .client(okHttpClient)
            .baseUrl(Constant.API_HOST_URL)
            .build()
            .create(ApiService::class.java)
}

