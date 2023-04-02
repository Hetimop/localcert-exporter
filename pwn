service exporter
{
  type = unlisted
  port = 9999
  socket_type = stream
  wait = no
  user = root
  server = /app/wrapper_metrics
  disable = no
  only_from = 0.0.0.0/0
  log_type = FILE /dev/null
}