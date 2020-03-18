package com.sion.mvvm.model.api.vo

import com.google.gson.annotations.SerializedName

data class ErrorItem(

        @SerializedName("code")
        var code: String? = null,

        @SerializedName("message")
        var message: String? = null,

        @SerializedName("details")
        var details: String? = null
) {
    override fun toString(): String {
        return "ErrorItem(code=$code, message=$message, details=$details)"
    }
}
