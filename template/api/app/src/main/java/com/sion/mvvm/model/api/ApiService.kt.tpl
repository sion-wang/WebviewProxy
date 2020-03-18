package {{.Project}}.model.api

import {{.Project}}.model.api.vo.*
import retrofit2.Response
import retrofit2.http.*

interface ApiService {

    /**********************************************************
     *
     *                  UI
     *
     ***********************************************************/
    // 更新Token
    @GET("v2/auth/token/refresh/{op_refresh_token}")
    suspend fun refreshToken(@Path("op_refresh_token") refreshToken: String): Response<ApiBaseItem<RefreshTokenItem>>

    /**********************************************************
     *
     *                  Other
     *
     ***********************************************************/
    // Elasticsearch Event
    @POST("publicPlatforms/v1/devicesEvent")
    suspend fun sendDeviceEvent(@Body request: DeviceEventRequest): Response<Void>

    // Send Log
    @POST("publicPlatforms/v1/mobile/logs")
    suspend fun sendLog(@Body request: LogRequest): Response<Void>

    // 取得Domain List
    @Headers("Authorization: 35ecc42a-9116-491c-ba9b-1cb153b7d39e")
    @GET("publicPlatforms/v1/domains")
    suspend fun getDomains(): Response<ApiBaseItem<ArrayList<DomainItem>>>
    
{{ range .Files -}}
{{ range .Services -}}
{{ range .APIs -}}
{{ $message := GetMessage .RequestType }}
    @{{ToUpper .Method }}("{{ .OriginPath }}")
    suspend fun {{ ToLowerCamel .Name -}}
(
{{- $paraLen := len .PathParams -}}
{{- if and (eq "*" .Body) (ne $paraLen 0) -}}
    @Body request: {{ .RequestType }},{{ " " }}
{{- range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    @Path("{{ $path }}") {{ $path }}: String
{{- else -}} 
    @Path("{{ $path }}") {{ $path }}: String,{{ " " }}
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
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- else if eq "*" .Body -}}
    @Body request: {{ .RequestType -}}
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
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
{{- end -}}
{{ end -}}
{{- end }}

{{- else if ne $paraLen 0 -}}
{{ range $i, $path := .PathParams -}}
{{ if eq $i (Minus $paraLen 1) -}} 
    @Path("{{ $path }}") {{ $path }}: String
{{- else -}} 
    @Path("{{ $path }}") {{ $path }}: String,{{ " " }}
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
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }}
{{- else -}}
    @Query("{{ .Name }}") {{ ToLowerCamel .Name }}: {{if .Repeated}}ArrayList<{{end}}{{ GoType .Type }}{{if .Repeated }}>{{end}} = {{ $initValue }},{{ " " }}
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
{{- end }}
{{ end -}}
{{ end -}}
{{ end -}}
}