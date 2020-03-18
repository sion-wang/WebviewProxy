package com.sion.mvvm.model.api.vo

import com.google.gson.annotations.SerializedName

data class RefreshTokenItem(

        @SerializedName("accessToken")
        var accessToken: String = "",

        @SerializedName("expiredIn")
        var expiredIn: Int = 0,

        @SerializedName("refreshToken")
        var refreshToken: String = "",

        @SerializedName("tokenType")
        var tokenType: String = ""
)