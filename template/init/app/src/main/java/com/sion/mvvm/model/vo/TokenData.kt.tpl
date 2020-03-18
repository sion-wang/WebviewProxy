package {{.Project}}.model.vo

data class TokenData(
    var accessToken: String = "",
    var refreshToken: String = ""
)