package {{.Project}}.model.manager

import {{.Project}}.BuildConfig
import {{.Project}}.model.api.ApiRepository
import {{.Project}}.model.api.ApiResult
import {{.Project}}.model.api.ApiService
import {{.Project}}.model.api.DomainInfo
import {{.Project}}.model.api.vo.ApiBaseItem
import {{.Project}}.model.api.vo.DomainItem
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import okhttp3.OkHttpClient
import retrofit2.HttpException
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import timber.log.Timber

class DomainManager(private val okHttpClient: OkHttpClient) {

    companion object {
        private const val GET_DOMAIN_RETRY_LIMIT = 10

        private const val API_URL_PREFIX = "https://api."
        private const val API_URL_POSTFIX = "/"

        private const val WS_URL_PREFIX = "wss://wss."
        private const val WS_URL_POSTFIX = "/"
        private const val WS_URL_PATH = "topics/atw-wx?token="
    }

    private var currentRootDomainIndex = 0
    private var currentDomainIndex = 0
    private val apiUrlList: ArrayList<String> = arrayListOf()
    private val wsUrlList: ArrayList<String> = arrayListOf()

    fun getDomain() = flow {
        val result = getRootApiRepository(currentRootDomainIndex).getDomains()
        val processResult = processDomainResult(result)
        if (!processResult) throw HttpException(result)
        emit(ApiResult.success(processResult))
    }
            .retryWhen { _, attempt ->
                when {
                    attempt > GET_DOMAIN_RETRY_LIMIT -> false
                    else -> {
                        changeRootDomainIndex()
                        true
                    }
                }
            }
            .flowOn(Dispatchers.IO)
            .onStart { emit(ApiResult.loading()) }
            .catch { e -> emit(ApiResult.error(e)) }
            .onCompletion {
                when (BuildConfig.FLAVOR) {
                    DomainInfo.FLAVOR_DEV,
                    DomainInfo.FLAVOR_SIT -> {
                        apiUrlList.add(BuildConfig.API_HOST)
                        wsUrlList.add(BuildConfig.WEB_SOCKET_HOST)
                    }
                }
                emit(ApiResult.loaded())
            }

    private fun processDomainResult(result: Response<ApiBaseItem<ArrayList<DomainItem>>>): Boolean {
        return when (BuildConfig.FLAVOR) {
            DomainInfo.FLAVOR_DEV,
            DomainInfo.FLAVOR_SIT -> {
                true
            }
            else -> {
                Timber.d("Domain result: $result")
                apiUrlList.clear()
                wsUrlList.clear()
                if (result.isSuccessful) {
                    val domains = result.body()?.data ?: arrayListOf()
                    for (item in domains) {
                        apiUrlList.add(
                                StringBuilder(API_URL_PREFIX)
                                        .append(item.domain)
                                        .append(API_URL_POSTFIX)
                                        .toString()
                        )
                        wsUrlList.add(
                                StringBuilder(WS_URL_PREFIX)
                                        .append(item.domain)
                                        .append(WS_URL_POSTFIX)
                                        .append(WS_URL_PATH)
                                        .toString()
                        )
                    }
                    true
                } else {
                    false
                }
            }
        }
    }

    private fun changeRootDomainIndex() {
        if (DomainInfo.getDomain().isNotEmpty()) {
            currentRootDomainIndex = ++currentRootDomainIndex % DomainInfo.getDomain().size
        }
    }

    private fun getRootApiRepository(index: Int): ApiRepository {
        Timber.d("GetRootApiRepository index: $index")
        val retrofit =
                Retrofit.Builder()
                        .addConverterFactory(GsonConverterFactory.create(Gson()))
                        .client(okHttpClient)
                        .baseUrl(DomainInfo.getDomain()[index])
                        .build()
        val apiService = retrofit.create(ApiService::class.java)
        return ApiRepository(apiService)
    }

    fun getApiRepository(): ApiRepository {
        Timber.d("CurrentDomainIndex: $currentDomainIndex")

        val url = when {
            currentDomainIndex < apiUrlList.size -> apiUrlList[currentDomainIndex]
            else -> DomainInfo.getDomain()[currentRootDomainIndex]
        }

        val retrofit =
                Retrofit.Builder()
                        .addConverterFactory(GsonConverterFactory.create(Gson()))
                        .client(okHttpClient)
                        .baseUrl(url)
                        .build()
        val apiService = retrofit.create(ApiService::class.java)
        return ApiRepository(apiService)
    }

    fun getWsUrl(): String {
        return if (wsUrlList.isNotEmpty() && currentDomainIndex < wsUrlList.size) {
            wsUrlList[currentDomainIndex]
        } else {
            ""
        }
    }

    fun getApiUrl(): String {
        return when {
            currentDomainIndex < apiUrlList.size -> apiUrlList[currentDomainIndex]
            else -> DomainInfo.getDomain()[currentRootDomainIndex]
        }
    }

    fun changeDomainIndex() {
        if (apiUrlList.size > 0) {
            currentDomainIndex = ++currentDomainIndex % apiUrlList.size
        }
    }
}