package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName

data class DomainItem(

        @SerializedName("id")
        var id: Int = 0,

        @SerializedName("type") // 1:域名| 2:IP
        var type: Int = 0,

        @SerializedName("domain")
        var domain: String = "",

        @SerializedName("sortBy")
        var sortBy: Int = 0

)