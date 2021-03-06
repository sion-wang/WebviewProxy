package com.sion.mvvm.model.api

import com.sion.mvvm.model.api.ExceptionResult.*
import com.sion.mvvm.widget.utility.AppUtils
import retrofit2.HttpException
import timber.log.Timber

fun Throwable.handleException(processException: (ExceptionResult) -> Unit): ExceptionResult {
    val result = when (this) {
        is HttpException -> {
            val httpExceptionData = AppUtils.getHttpExceptionData(this)
            val result = ApiRepository.isRefreshTokenFailed(httpExceptionData.errorItem.code)
            Timber.d("isRefreshTokenFailed: $result")
            if (result) {
                RefreshTokenExpired
            } else {
                HttpError(httpExceptionData)
            }
        }
        else -> {
            Crash(this)
        }
    }

    processException(result)

    return result
}