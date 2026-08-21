{{- define "mi-chart.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "mi-chart.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

