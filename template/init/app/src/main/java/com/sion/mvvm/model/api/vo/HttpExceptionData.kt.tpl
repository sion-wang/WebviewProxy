package {{.Project}}.model.api.vo

import retrofit2.HttpException

data class HttpExceptionData(
        var errorItem: ErrorItem,
        var httpExceptionClone: HttpException,
        var url: String = ""
)
