package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName

data class LogRequest(

        @SerializedName("level") // level: 0:debug | 1:info | 2:warn | 3:error | 4:panic | 5:fatal
        val level: Int? = null,

        @SerializedName("full_message") // 訊息
        var errorMessage: String? = null,

        @SerializedName("osVersion")
        val osVersion: String? = null,

        @SerializedName("appVersion")
        val appVersion: String? = null,

        @SerializedName("deviceID")
        val deviceId: String? = null,

        @SerializedName("deviceTime")
        val deviceTime: Long? = null,

        @SerializedName("event")
        val event: String? = null,

        @SerializedName("platform")
        val platform: String? = null

)