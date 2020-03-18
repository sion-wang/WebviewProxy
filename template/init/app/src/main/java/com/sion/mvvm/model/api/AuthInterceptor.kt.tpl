package {{.Project}}.model.api

import android.text.TextUtils
import {{.Project}}.BuildConfig
import {{.Project}}.model.api.ApiRepository.Companion.AUTHORIZATION
import {{.Project}}.model.api.ApiRepository.Companion.X_APP_VERSION
import {{.Project}}.model.api.ApiResult.Empty
import {{.Project}}.model.api.ApiResult.Error
import {{.Project}}.model.manager.AccountManager
import {{.Project}}.model.manager.DomainManager
import {{.Project}}.model.pref.Pref
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response
import org.koin.core.KoinComponent
import org.koin.core.inject
import timber.log.Timber
import java.net.HttpURLConnection
import java.net.UnknownHostException

class AuthInterceptor(private val pref: Pref) : Interceptor, KoinComponent {

    private val accountManager: AccountManager by inject()
    private val domainManager: DomainManager by inject()

    override fun intercept(chain: Interceptor.Chain): Response {
        try {
            val request = chain.request()
            val url = request.url
            val response =
//                    if (url.toString().contains("/publicStorage/v1/download") &&
//                            BuildConfig.FLAVOR != domainManager.FLAVOR_DEV &&
//                            BuildConfig.FLAVOR != domainManager.FLAVOR_SIT) {
//                        val newUrl = HttpUrl.parse(pref.aliUrl)
//                        Timber.d("Ali Url: $newUrl")
//                        val downloadRequest = request.newBuilder()
//                                .url(newUrl?.url()!!)
//                                .addHeader(X_APP_VERSION, BuildConfig.VERSION_NAME).build()
//                        chain.proceed(downloadRequest)
//                    } else {
                        chain.proceed(chain.buildRequest())
//                    }

            Timber.d("Response code: ${response.code}")

            return when (response.code) {
                HttpURLConnection.HTTP_UNAUTHORIZED -> {
                    runBlocking {
                        withContext(Dispatchers.IO) {
                            accountManager.refreshToken()
                                    .collect {
                                        when (it) {
                                            is Empty -> Timber.d("Refresh token successful!")
                                            is Error -> Timber.e("Refresh token error: $it")
                                        }
                                    }
                        }
                        chain.proceed(chain.buildRequest())
                    }
                }
                else -> response
            }
        } catch (e: UnknownHostException) {
            domainManager.changeDomainIndex()
            Timber.d("UnknownHostException")
            return chain.proceed(chain.buildRequest())
        }
    }

    private fun Interceptor.Chain.buildRequest(): Request {
        val host = request().url.host
        val newHost = domainManager.getApiUrl().toHttpUrlOrNull()?.host
        Timber.d("host: $host, newHost: $newHost")
        val requestBuilder = when {
            !TextUtils.isEmpty(newHost) && !TextUtils.equals(host, newHost) -> {
                val newUrl = request().url.newBuilder().host(newHost!!).build()
                Timber.d("newUrl: $newUrl")
                request().newBuilder()
                        .url(newUrl)
                        .addHeader(X_APP_VERSION, BuildConfig.VERSION_NAME)
            }
            else -> {
                request().newBuilder()
                        .addHeader(X_APP_VERSION, BuildConfig.VERSION_NAME)
            }
        }

        val url = request().url.toString()

        if (!TextUtils.isEmpty(pref.token.accessToken)) {
            if (!url.contains("/publicPlatforms/v1/domains")) { //getDomain has a specific token, no need to set user token
                val auth = StringBuilder(ApiRepository.BEARER)
                        .append(pref.token.accessToken)
                        .toString()
                requestBuilder.addHeader(AUTHORIZATION, auth)
            }
        }

        return requestBuilder.build()
    }
}
