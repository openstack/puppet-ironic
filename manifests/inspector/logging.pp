# Class ironic::inspector::logging
#
#  ironic-inspector logging configuration
#
# == parameters
#
#  [*debug*]
#    (Optional) Should the daemons log debug messages
#    Defaults to $facts['os_service_default']
#
#  [*use_syslog*]
#    (Optional) Use syslog for logging.
#    Defaults to $facts['os_service_default']
#
#  [*use_json*]
#    (Optional) Use json for logging.
#    Defaults to $facts['os_service_default']
#
#  [*use_stderr*]
#    (optional) Use stderr for logging
#    Defaults to $facts['os_service_default']
#
#  [*log_facility*]
#    (Optional) Syslog facility to receive log lines.
#    Defaults to $facts['os_service_default']
#
#  [*log_dir*]
#    (optional) Directory where logs should be stored.
#    If set to $facts['os_service_default'], it will not log to any directory.
#    Defaults to '/var/log/ironic-inspector'
#
#  [*log_file*]
#   (Optional) File where logs should be stored.
#   Defaults to $facts['os_service_default']
#
#  [*logging_context_format_string*]
#    (optional) Format string to use for log messages with context.
#    Defaults to $facts['os_service_default']
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [%(request_id)s %(user_identity)s] %(instance)s%(message)s'
#
#  [*logging_default_format_string*]
#    (optional) Format string to use for log messages without context.
#    Defaults to$facts['os_service_default']
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [-] %(instance)s%(message)s'
#
#  [*logging_debug_format_suffix*]
#    (optional) Formatted data to append to log format when level is DEBUG.
#    Defaults to $facts['os_service_default']
#    Example: '%(funcName)s %(pathname)s:%(lineno)d'
#
#  [*logging_exception_prefix*]
#    (optional) Prefix each line of exception output with this format.
#    Defaults to $facts['os_service_default']
#    Example: '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s'
#
#  [*log_config_append*]
#    The name of an additional logging configuration file.
#    Defaults to $facts['os_service_default']
#    See https://docs.python.org/2/howto/logging.html
#
#  [*default_log_levels*]
#    (optional) Hash of logger (keys) and level (values) pairs.
#    Defaults to $facts['os_service_default']
#    Example:
#      { 'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
#        'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
#        'requests.packages.urllib3.connectionpool' => 'WARN' }
#
#  [*publish_errors*]
#    (optional) Publish error events (boolean value).
#    Defaults to $facts['os_service_default']
#
#  [*fatal_deprecations*]
#    (optional) Make deprecations fatal (boolean value)
#    Defaults to $facts['os_service_default']
#
#  [*instance_format*]
#    (optional) If an instance is passed with the log message, format it
#               like this (string value).
#    Defaults to $facts['os_service_default']
#    Example: '[instance: %(uuid)s] '
#
#  [*instance_uuid_format*]
#    (optional) If an instance UUID is passed with the log message, format
#               it like this (string value).
#    Defaults to $facts['os_service_default']
#    Example: instance_uuid_format='[instance: %(uuid)s] '
#
#  [*log_date_format*]
#    (optional) Format string for %%(asctime)s in log records.
#    Defaults to $facts['os_service_default']
#    Example: 'Y-%m-%d %H:%M:%S'
#
class ironic::inspector::logging(
  $use_syslog                    = $facts['os_service_default'],
  $use_json                      = $facts['os_service_default'],
  $use_stderr                    = $facts['os_service_default'],
  $log_facility                  = $facts['os_service_default'],
  $log_dir                       = '/var/log/ironic-inspector',
  $log_file                      = $facts['os_service_default'],
  $debug                         = $facts['os_service_default'],
  $logging_context_format_string = $facts['os_service_default'],
  $logging_default_format_string = $facts['os_service_default'],
  $logging_debug_format_suffix   = $facts['os_service_default'],
  $logging_exception_prefix      = $facts['os_service_default'],
  $log_config_append             = $facts['os_service_default'],
  $default_log_levels            = $facts['os_service_default'],
  $publish_errors                = $facts['os_service_default'],
  $fatal_deprecations            = $facts['os_service_default'],
  $instance_format               = $facts['os_service_default'],
  $instance_uuid_format          = $facts['os_service_default'],
  $log_date_format               = $facts['os_service_default'],
) {

  include ironic::deps

  oslo::log { 'ironic_inspector_config':
    debug                         => $debug,
    use_stderr                    => $use_stderr,
    use_syslog                    => $use_syslog,
    use_json                      => $use_json,
    log_dir                       => $log_dir,
    log_file                      => $log_file,
    syslog_log_facility           => $log_facility,
    logging_context_format_string => $logging_context_format_string,
    logging_default_format_string => $logging_default_format_string,
    logging_debug_format_suffix   => $logging_debug_format_suffix,
    logging_exception_prefix      => $logging_exception_prefix,
    log_config_append             => $log_config_append,
    default_log_levels            => $default_log_levels,
    publish_errors                => $publish_errors,
    fatal_deprecations            => $fatal_deprecations,
    instance_format               => $instance_format,
    instance_uuid_format          => $instance_uuid_format,
    log_date_format               => $log_date_format,
  }

}
