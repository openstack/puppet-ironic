# Configure the ironic-novncproxy service
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package resource.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not.
#   Defaults to true.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*host_ip*]
#  (optional) The IP address or hostname on which ironic-novncproxy listens.
#  Defaults to $facts['os_service_default']
#
# [*port*]
#  (optional) The TCP port on which ironic-novncproxy listens.
#  Defaults to $facts['os_service_default']
#
# [*public_url*]
#  (optional) Public URL to use when building the links to the noVNC client
#  browser page.
#  Defaults to $facts['os_service_default']
#
# [*enable_ssl*]
#  (optional) Enable the integrated stand-alone noVNC to service requests via
#  HTTPS instead of HTTP
#  Defaults to $facts['os_service_default']
#
# [*novnc_web*]
#  (optional) Path to directory with content which will be served by a web
#  server.
#  Defaults to $facts['os_service_default']
#
# [*novnc_record*]
#  (optional) Filename that will be used for storing websocket frames received
#  and sent by a VNC proxy service running on this host.
#  Defaults to $facts['os_service_default']
#
# [*novnc_auth_schemes*]
#  (optional) The allowed authentication schemes to use with proxied VNC
#  console
#  Defaults to $facts['os_service_default']
#
# [*token_timeout*]
#  (optional) The lifetime of a console auth token (in seconds).
#  Defaults to $facts['os_service_default']
#
# [*expire_console_session_interval*]
#  (optional) Interval (in seconds) between periodic checks to determine
#  whether active console sessions have expired and need to be closed.
#  Defaults to $facts['os_service_default']
#
class ironic::vnc(
  $package_ensure                  = present,
  Boolean $enabled                 = true,
  Boolean $manage_service          = true,
  $host_ip                         = $facts['os_service_default'],
  $port                            = $facts['os_service_default'],
  $public_url                      = $facts['os_service_default'],
  $enable_ssl                      = $facts['os_service_default'],
  $novnc_web                       = $facts['os_service_default'],
  $novnc_record                    = $facts['os_service_default'],
  $novnc_auth_schemes              = $facts['os_service_default'],
  $token_timeout                   = $facts['os_service_default'],
  $expire_console_session_interval = $facts['os_service_default'],
) inherits ironic::params {

  include ironic::deps

  ironic_config {
    'vnc/enabled':                         value => $enabled;
    'vnc/host_ip':                         value => $host_ip;
    'vnc/port':                            value => $port;
    'vnc/public_url':                      value => $public_url;
    'vnc/enable_ssl':                      value => $enable_ssl;
    'vnc/novnc_web':                       value => $novnc_web;
    'vnc/novnc_record':                    value => $novnc_record;
    'vnc/novnc_auth_schemes':              value => join(any2array($novnc_auth_schemes), ',');
    'vnc/token_timeout':                   value => $token_timeout;
    'vnc/expire_console_session_interval': value => $expire_console_session_interval;
  }

  if $::ironic::params::novncproxy_package {
    package { 'ironic-novncproxy':
      ensure => $package_ensure,
      name   => $::ironic::params::novncproxy_package,
      tag    => ['openstack', 'ironic-package'],
    }
  }

  if $::ironic::params::novncproxy_service {
    if $manage_service {
      if $enabled {
        $ensure = 'running'
      } else {
        $ensure = 'stopped'
      }

      # Manage service
      service { 'ironic-novncproxy':
        ensure    => $ensure,
        name      => $::ironic::params::novncproxy_service,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'ironic-service',
      }
    }
  }
}
