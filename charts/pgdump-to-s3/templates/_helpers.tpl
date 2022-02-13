{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pg_dump-to-s3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pg_dump-to-s3.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "pg_dump-to-s3.nginxname" -}}
{{ include "pg_dump-to-s3.fullname" . }}-nginx
{{- end -}}

{{- define "pg_dump-to-s3.nginxcert" -}}
{{ include "pg_dump-to-s3.fullname" .}}-cert
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pg_dump-to-s3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pg_dump-to-s3.labels" -}}
helm.sh/chart: {{ include "pg_dump-to-s3.chart" . }}
monitoring: apps
{{ include "pg_dump-to-s3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "pg_dump-to-s3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pg_dump-to-s3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


