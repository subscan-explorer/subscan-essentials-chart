{{- define "subscan-essentials.fullname" -}}
subscan-essentials-{{- . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "subscan-essentials.networkName" -}}
{{- include "subscan-essentials.fullname" . | trimPrefix "subscan-essentials-" }}
{{- end }}

{{- define "subscan-essentials.selectorLabels" -}}
app.kubernetes.io/name: subscan-essentials-backend
app.kubernetes.io/instance: {{ template "subscan-essentials.fullname" . }}
{{- end }}

{{- define "subscan-essentials.labels" -}}
{{- include "subscan-essentials.selectorLabels" . | nindent 4 }}
{{- end }}

{{- define "subscan-essentials.backend.reload" -}}
secret.reloader.stakater.com/reload:  {{ include "subscan-essentials.fullname" . }}-envvars
{{- end }}

{{- define "subscan-essentials.ui.reload" -}}
configmap.reloader.stakater.com/reload:  subscan-essentials-{{- include "subscan-essentials.networkName" . }}-backend-subdomain
{{- end }}