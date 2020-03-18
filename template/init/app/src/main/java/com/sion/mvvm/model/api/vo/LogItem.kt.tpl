package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName

data class LogItem(

        @SerializedName("clazz")
        val clazz: String = "",

        @SerializedName("eventType")
        val eventType: String = "",

        @SerializedName("action")
        val action: String = "",

        @SerializedName("msg")
        val msg: String = "",

        @SerializedName("account")
        val account: String = ""
)