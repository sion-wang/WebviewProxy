package {{.Project}}.model.api

import {{.Project}}.model.manager.DeviceManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import okhttp3.Headers
import okhttp3.Interceptor
import okhttp3.Response
import okhttp3.internal.http.promisesBody
import okio.Buffer
import org.koin.core.KoinComponent
import org.koin.core.inject
import java.io.EOFException
import java.nio.charset.Charset

class ApiLogInterceptor : Interceptor, KoinComponent {

    companion object {
        private const val PATH_SEND_LOG = "publicPlatforms/v1/mobile/logs"
        private const val PATH_UPLOAD_IMAGE = "agents/v2/wechat/wechatOrders"
    }

    private val deviceManager: DeviceManager by inject()

    private val utf8 = Charset.forName("UTF-8")

    private fun push(log: StringBuilder) = runBlocking {
        withContext(Dispatchers.IO) {
            deviceManager.sendLog(log.toString())
                    .collect()
        }
    }

    override fun intercept(chain: Interceptor.Chain): Response {
        val log = StringBuilder("")

        val request = chain.request()
        val requestBody = request.body
        val hasRequestBody = requestBody != null

        val path = request.url.encodedPath

        if (path.contains(PATH_SEND_LOG)) {
            return chain.proceed(request)
        }

        log.append("--> API request *${request.method}* (${request.url})").append("\n")

        val requestHeaderNames = request.headers.names().filter { it == ApiRepository.AUTHORIZATION || it == ApiRepository.X_REQUEST_ID }
        requestHeaderNames.forEach { name ->
            log.append("--> ($path) $name: ${request.headers[name]}").append("\n")
        }

        if (hasRequestBody && path.contains(PATH_UPLOAD_IMAGE)) {
            log.append("--> ($path) body: base64 image.").append("\n")
        } else if (hasRequestBody && !bodyHasUnknownEncoding(request.headers)) {
            val buffer = Buffer()
            requestBody!!.writeTo(buffer)
            var charset = utf8
            val contentType = requestBody.contentType()
            if (contentType != null) {
                charset = contentType.charset(utf8)
            }
            if (isPlaintext(buffer)) {
                log.append("--> ($path) body: ${buffer.readString(charset)}").append("\n")
            }
        }

        val response: Response
        response = try {
            chain.proceed(request)
        } catch (e: Exception) {
            log.append("<-- API response (${request.url})").append("\n")
            log.append("<-- ($path) $e").append("\n")
            throw e
        }
        val responseBody = response.body
        val contentLength = responseBody!!.contentLength()
        log.append("<-- API response (${response.request.url})").append("\n")
        log.append("<-- ($path) code: ${response.code}${if (response.message.isEmpty()) "" else " " + response.message}").append("\n")

        val responseHeaders = response.headers
        log.append("<-- ($path) ${ApiRepository.X_REQUEST_ID}: ${responseHeaders.get(ApiRepository.X_REQUEST_ID)}").append("\n")

        if (response.promisesBody() && !bodyHasUnknownEncoding(response.headers)) {
            val source = responseBody.source()
            source.request(Long.MAX_VALUE) // Buffer the entire body.
            val buffer = source.buffer()
            var charset = utf8
            val contentType = responseBody.contentType()
            if (contentType != null) {
                charset = contentType.charset(utf8)
            }
            if (!isPlaintext(buffer)) {
                log.append("<-- ($path) body: binary ${buffer.size}-byte body omitted").append("\n")
                return response
            }
            if (contentLength != 0L) {
                log.append("<-- ($path) body: ${buffer.clone().readString(charset)}").append("\n")
            }
        }
        push(log)
        return response
    }

    /**
     * Returns true if the body in question probably contains human readable text. Uses a small sample
     * of code points to detect unicode control characters commonly used in binary file signatures.
     */
    private fun isPlaintext(buffer: Buffer): Boolean {
        return try {
            val prefix = Buffer()
            val byteCount = if (buffer.size < 64) buffer.size else 64
            buffer.copyTo(prefix, 0, byteCount)
            for (i in 0..15) {
                if (prefix.exhausted()) {
                    break
                }
                val codePoint = prefix.readUtf8CodePoint()
                if (Character.isISOControl(codePoint) && !Character.isWhitespace(codePoint)) {
                    return false
                }
            }
            true
        } catch (e: EOFException) {
            false // Truncated UTF-8 sequence.
        }
    }

    private fun bodyHasUnknownEncoding(headers: Headers): Boolean {
        val contentEncoding = headers["Content-Encoding"]
        return (contentEncoding != null && !contentEncoding.equals("identity", ignoreCase = true)
                && !contentEncoding.equals("gzip", ignoreCase = true))
    }
}
