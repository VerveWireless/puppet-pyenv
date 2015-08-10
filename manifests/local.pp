# Sets directory specific python virtualenv version
define pyenv::local(
  $path,
  $user,
  $group=$user,
  $virtual_env_name=$title
) {

  exec { "local virtualenv ${virtual_env_name} ${path}":
    command  => "cd ${path} && pyenv local ${virtual_env_name}",
    user     => $user,
    group    => $group,
    path     => ['/bin', '/usr/bin', '/usr/sbin'],
    cwd      => $path,
    provider => 'bash',
  }
}

