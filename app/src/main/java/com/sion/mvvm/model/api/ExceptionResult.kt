package com.sion.mvvm.model.api

import com.sion.mvvm.model.api.vo.HttpExceptionData

sealed class ExceptionResult {

    object RefreshTokenExpired : ExceptionResult()

    data class HttpError(val httpExceptionData: HttpExceptionData) : ExceptionResult()

    data class Crash(val throwable: Throwable) : ExceptionResult()
}
