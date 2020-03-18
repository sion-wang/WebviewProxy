package {{.Project}}.model.api

import {{.Project}}.model.api.vo.*
import retrofit2.Response

class ApiRepository(private val apiService: ApiService) {

    companion object {
        const val X_APP_VERSION = "x-app-version"
        const val X_REQUEST_ID = "x-request-id"
        const val BEARER = "Bearer "
        const val AUTHORIZATION = "Authorization"
        const val MEDIA_TYPE_JSON = "application/json"

        fun isRefreshTokenFailed(code: String?): Boolean {
            return code == ErrorCode.TOKEN_NOT_FOUND
        }
    }

    /**********************************************************
     *
     *                  UI
     *
     ***********************************************************/
    // 更新Token
    suspend fun refreshToken(token: String): Response<ApiBaseItem<RefreshTokenItem>> {
        return apiService.refreshToken(token)
    }

    /**********************************************************
     *
     *                  Other
     *
     ***********************************************************/
    // Elasticsearch Event
    suspend fun sendDeviceEvent(request: DeviceEventRequest): Response<Void> {
        return apiService.sendDeviceEvent(request)
    }

    // Send Log
    suspend fun sendLog(request: LogRequest): Response<Void> {
        return apiService.sendLog(request)
    }

    suspend fun getDomains(): Response<ApiBaseItem<ArrayList<DomainItem>>> {
        return apiService.getDomains()
    }

{{ range .Files -}}
{{ range .Services -}}
{{ range .APIs -}}
{{ $message := GetMessage .RequestType }}
    suspend fun {{ ToLowerCamel .Name -}}
(
{{- $paraLen := len .PathParams -}}
{{- if and (eq "*" .Body) (ne $paraLen 0) -}}
    request: {{ .RequestType }},{{ " " }}
{{- range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    {{ $path }}: String
{{- else -}} 
    {{ $path }}: String,{{ " " }}
{{- end -}}
{{ if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{ $type := GoType .Type -}}
{{- $initValue := "\"\"" -}}
{{- if .Repeated -}}
    {{- $initValue = "arrayListOf()" -}}
{{- else if or (eq $type "Int") (eq $type "Long") -}}
    {{- $initValue = "0" -}}
{{- else if or (eq $type "String") (eq $type "Timestamp") -}}
    {{- $initValue = "\"\"" -}}
{{- else if or (eq $type "Boolean") -}}
    {{- $initValue = "false" -}}
{{- end -}}
{{ if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- else if eq "*" .Body -}}
    request: {{ .RequestType -}}
{{ if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{ $type := GoType .Type -}}
{{- $initValue := "\"\"" -}}
{{- if .Repeated -}}
    {{- $initValue = "arrayListOf()" -}}
{{- else if or (eq $type "Int") (eq $type "Long") -}}
    {{- $initValue = "0" -}}
{{- else if or (eq $type "String") (eq $type "Timestamp") -}}
    {{- $initValue = "\"\"" -}}
{{- else if or (eq $type "Boolean") -}}
    {{- $initValue = "false" -}}
{{- end -}}
{{ if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
{{- end -}}
{{ end -}}
{{- end }}

{{- else if ne $paraLen 0 -}}
{{ range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    {{ $path }}: String
{{- else -}} 
    {{ $path }}: String,{{ " " }}
{{- end -}}
{{ if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{ $type := GoType .Type -}}
{{- $initValue := "\"\"" -}}
{{- if .Repeated -}}
    {{- $initValue = "arrayListOf()" -}}
{{- else if or (eq $type "Int") (eq $type "Long") -}}
    {{- $initValue = "0" -}}
{{- else if or (eq $type "String") (eq $type "Timestamp") -}}
    {{- $initValue = "\"\"" -}}
{{- else if or (eq $type "Boolean") -}}
    {{- $initValue = "false" -}}
{{- end -}}
{{- if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
{{- end -}}
{{ end -}}
{{- end }}
{{- end }}
{{- end -}}):{{ " " }}

{{- if eq "Empty" .ReturnsType -}}
    Response<Void>
{{- else if Contains .Name "List" -}}   
    Response<{{ .ReturnsType }}>
{{- else -}}
    Response<ApiBaseItem<{{ .ReturnsType }}>>
{{- end }}{{ " " }}{
        return apiService.{{ ToLowerCamel .Name }}( 

{{- if and (eq "*" .Body) (ne $paraLen 0) -}}
    request,{{ " " }}
{{- range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    {{ $path }}
{{- else -}} 
    {{ $path }},{{ " " }}
{{- end -}}
{{ if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{ if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}
{{- else -}}
    {{ ToLowerCamel .Name }},{{ " " }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- else if eq "*" .Body -}}
    request
{{- if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{ if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}
{{- else -}}
    {{ ToLowerCamel .Name }},{{ " " }}
{{- end -}}
{{ end -}}
{{- end }}

{{- else if ne $paraLen 0 -}}
{{ range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    {{ $path }}
{{- else -}} 
    {{ $path }},{{ " " }}
{{- end -}}
{{ if $message -}}
{{- ", " }}
{{- $messageLen := len $message.Fields -}}
{{ range $i, $field := $message.Fields -}}
{{- if eq $i (Minus $messageLen 1) -}}
    {{ ToLowerCamel .Name }}
{{- else -}}
    {{ ToLowerCamel .Name }},{{ " "}}
{{- end -}}
{{ end -}}
{{- end }}
{{- end -}}
{{- end -}})  
    }
{{ end -}}
{{ end -}}
{{ end -}}
}

