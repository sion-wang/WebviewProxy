package com.sion.mvvm.di

import com.apollographql.apollo.ApolloClient
import com.apollographql.apollo.cache.CacheHeaders
import com.apollographql.apollo.interceptor.ApolloInterceptor
import com.apollographql.apollo.interceptor.ApolloInterceptorChain
import com.sion.mvvm.BuildConfig
import com.sion.mvvm.Constant
import com.sion.mvvm.model.api.ApiLogInterceptor
import com.sion.mvvm.model.api.ApiService
import com.sion.mvvm.model.api.AuthInterceptor
import com.sion.mvvm.model.pref.Pref
import com.facebook.stetho.okhttp3.StethoInterceptor
import com.google.gson.Gson
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
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
    single { provideApolloClient() }
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

fun provideApolloClient(): ApolloClient {
    val okHttpClient = OkHttpClient.Builder()
        .addInterceptor(
            object : Interceptor {
                override fun intercept(chain: Interceptor.Chain): Response {
                    val original = chain.request()
                    val builder = original.newBuilder().method(original.method, original.body)
                    builder.header("x-graph-auth", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.Cn9DXn-87qtUaiVZTWkuy-oA6vSztNNuVVBj8Rtef5w")
                    return chain.proceed(builder.build())
                }
            }
        ).build()

    return ApolloClient.builder()
        .serverUrl("http://18.222.145.190:8777/graphql")
        .okHttpClient(okHttpClient)
        .build()
}

fun provideApiService(okHttpClient: OkHttpClient): ApiService {
    return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .client(okHttpClient)
            .baseUrl(Constant.API_HOST_URL)
            .build()
            .create(ApiService::class.java)
}

