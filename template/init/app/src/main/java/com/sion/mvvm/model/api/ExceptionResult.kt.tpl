package {{.Project}}.model.api

import {{.Project}}.model.api.vo.HttpExceptionData

sealed class ExceptionResult {

    object RefreshTokenExpired : ExceptionResult()

    data class HttpError(val httpExceptionData: HttpExceptionData) : ExceptionResult()

    data class Crash(val throwable: Throwable) : ExceptionResult()
}
