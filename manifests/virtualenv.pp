define pyenv::virtualenv(
  $user,
  $group = $user,
  $python_source_version,
  $virtual_env_name=$title,
) {

  exec { "virtual env ${virtual_env_name} for ${user}":
    command  => "pyenv virtualenv ${python_source_version} ${virtual_env_name}",
    user     => $user,
    group    => $group,
    path     => ['/bin', '/usr/bin', '/usr/sbin'],
    cwd      => "/home/${user}",
    provider => 'bash',
    creates  => "/home/${user}/.pyenv/versions/${virtual_env_name}" ,
    require  => Exec["pyenv::virtualenvinit ${user}"],
  }
}
