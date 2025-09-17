{{/* Nombre base del chart */}}
{{- define "app-template-nestjs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Nombre completo del release */}}
{{- define "app-template-nestjs.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Labels comunes */}}
{{- define "app-template-nestjs.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "app-template-nestjs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{/* Selector labels */}}
{{- define "app-template-nestjs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app-template-nestjs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Nombre del servicio de MongoDB */}}
{{- define "app-template-nestjs.mongodb.fullname" -}}
{{- printf "%s-mongodb" (include "app-template-nestjs.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
