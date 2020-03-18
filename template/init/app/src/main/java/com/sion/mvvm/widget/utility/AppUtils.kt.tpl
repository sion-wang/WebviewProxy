package {{.Project}}.widget.utility

import android.annotation.SuppressLint
import android.provider.Settings
import {{.Project}}.App
import {{.Project}}.model.api.ApiRepository
import {{.Project}}.model.api.vo.ErrorItem
import {{.Project}}.model.api.vo.HttpExceptionData
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.Protocol
import okhttp3.Request
import okhttp3.ResponseBody.Companion.toResponseBody
import retrofit2.HttpException
import retrofit2.Response
import timber.log.Timber
import java.io.PrintWriter
import java.io.StringWriter
import java.text.SimpleDateFormat
import java.util.*

object AppUtils {

    private const val TIME_ZONE_OFFSET: Long = 1000 * 60 * 60 * 8  //UTC - 8 hours
    private const val MIN_CLICK_DELAY_TIME = 1000
    private var lastClickTime = 0L

    @SuppressLint("HardwareIds")
    fun getAndroidID(): String {
        return Settings.Secure.getString(
            App.applicationContext().contentResolver,
            Settings.Secure.ANDROID_ID
        )
    }

    fun getSystemProperty(key: String, defaultValue: String): String {
        var value = defaultValue
        try {
            value = Class.forName("android.os.SystemProperties")
                .getMethod("get", String::class.java)
                .invoke(null, key) as String
            if (value == "") {
                value = defaultValue
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return value
    }

    fun convertUtcByDateFormat(utcTime: String, pattern: String): String {
        val sdf = SimpleDateFormat(pattern, Locale.getDefault())
        val date = utcToDate(utcTime)
        return sdf.format(date)
    }

    fun utcToDate(utcTime: String): Date {
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        return Date(sdf.parse(utcTime).time + TIME_ZONE_OFFSET)
    }

    fun isFastClick(clickDelay: Int = MIN_CLICK_DELAY_TIME): Boolean {
        val curClickTime = System.currentTimeMillis()
        var flag = false
        if ((curClickTime - lastClickTime) <= clickDelay) {
            flag = true
        } else {
            lastClickTime = curClickTime
        }
        return flag
    }

    fun getExceptionDetail(t: Throwable): String {
        return when (t) {
            is HttpException -> {
                val data = getHttpExceptionData(t)
                "$data, ${t.localizedMessage}"
            }
            else -> getStackTrace(t)
        }
    }

    fun getHttpExceptionData(httpException: HttpException): HttpExceptionData {
        val oriResponse = httpException.response()

        val url = oriResponse?.raw()?.request?.url.toString()
        Timber.d("url: $url")

        val errorBody = oriResponse?.errorBody()
        val jsonStr = errorBody?.string()
        val type = object : TypeToken<ErrorItem>() {}.type

        val errorItem: ErrorItem = try {
            Gson().fromJson(jsonStr, type)
        } catch (e: Exception) {
            e.printStackTrace()
            ErrorItem(null, null, null)
        }
        Timber.d("errorItem: $errorItem")

        val responseBody = Gson().toJson(ErrorItem(errorItem.code, errorItem.message, null))
            .toResponseBody(ApiRepository.MEDIA_TYPE_JSON.toMediaTypeOrNull())

        val rawResponse = okhttp3.Response.Builder()
            .code(httpException.code())
            .message(httpException.message())
            .protocol(Protocol.HTTP_1_1)
            .request(Request.Builder().url(url).build())
            .build()

        val response = Response.error<ErrorItem>(responseBody, rawResponse)

        val httpExceptionClone = HttpException(response)
        return HttpExceptionData(errorItem, httpExceptionClone, url)
    }

    private fun getStackTrace(t: Throwable): String {
        val sw = StringWriter(256)
        val pw = PrintWriter(sw, false)
        t.printStackTrace(pw)
        pw.flush()
        return sw.toString()
    }
}