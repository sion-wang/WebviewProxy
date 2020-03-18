package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName

data class DeviceEventRequest(

        @SerializedName("env")
        val env: String? = null,

        @SerializedName("project")
        val project: String? = null,

        @SerializedName("osVersion")
        val osVersion: String? = null,

        @SerializedName("appVersion")
        val appVersion: String? = null,

        @SerializedName("deviceID")
        val deviceId: String? = null,

        @SerializedName("userID")
        var userId: String? = null,

        @SerializedName("deviceTime")
        val deviceTime: Long? = null,

        @SerializedName("createdAt")
        val createdAt: String? = null,

        @SerializedName("location")
        var location: String? = null,

        @SerializedName("event")
        val event: String? = null,

        @SerializedName("level")
        val level: Int? = null,

        @SerializedName("platform")
        val platform: String? = null,

        @SerializedName("data")
        var data: Any? = null
)
