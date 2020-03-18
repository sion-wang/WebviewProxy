package com.sion.mvvm.model.api.vo

import com.google.gson.annotations.SerializedName

data class ApiBaseItem<T>(

        @SerializedName("data")
        val data: T
)
