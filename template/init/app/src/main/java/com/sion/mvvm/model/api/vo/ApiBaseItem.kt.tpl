package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName

data class ApiBaseItem<T>(

        @SerializedName("data")
        val data: T
)
