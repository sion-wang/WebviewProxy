package {{.Project}}.model.api.vo

import com.google.gson.annotations.SerializedName
{{ range .Files -}}
{{ range .Messages }}
data class {{ printf .Name }}(
{{ $length := len .Fields -}}
{{ $length := Minus $length 1 -}}
{{ range $i, $element := .Fields }}
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
    {{- else -}}
        {{- $initValue = "else type" -}}
    {{- end -}}

    @SerializedName("{{ .Name }}")  {{- if ne "" .Comment -}}{{"    "}}//{{.Comment -}}{{ end }}
    var {{ ToLowerCamel .Name }}: {{if ne $initValue "else type"}}{{if .Repeated}}ArrayList<{{end}}{{ GoType .Type}}{{if .Repeated}}>{{end}} = {{ $initValue }}{{else}}{{ GoType .Type}}{{end}}
    {{- if lt $i ($length) -}},{{ end }}
{{ end }}
)
{{ end -}}
{{ end -}}