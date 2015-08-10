# == Class pyenv::install
#
define pyenv::install(
  $user  = $title,
  $group = $user,
  $home  = '',
  $root  = '',
  $rc    = '.profile'
) {

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.pyenv", default => $root }

  $pyenvrc = "${home_path}/.pyenvrc"
  $shrc    = "${home_path}/${rc}"

  exec { "pyenv::checkout ${user}":
    command => "git clone https://github.com/yyuu/pyenv.git ${root_path}",
    user    => $user,
    group   => $group,
    creates => $root_path,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => 100,
    cwd     => $home_path,
    require => Package['git'],
  }

  exec { "pyenv::checkout virtualenv ${user}":
    command => "git clone https://github.com/yyuu/pyenv-virtualenv.git ${root_path}/plugins/pyenv-virtualenv",
    user    => $user,
    group   => $group,
    creates => "${root_path}/plugins/pyenv-virtualenv",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => 100,
    cwd     => $home_path,
    require => Exec["pyenv::checkout ${user}"],
  }

  exec { "pyenv::virtualenvinit ${user}":
    command => "echo 'eval \"$(pyenv virtualenv-init -)\"' >> ${shrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q \"virtualenv init\" ${shrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => Exec["pyenv::checkout virtualenv ${user}"],
  }

  file { "pyenv::pyenvrc ${user}":
    path    => $pyenvrc,
    owner   => $user,
    group   => $group,
    content => template('pyenv/pyenvrc.erb'),
    require => Exec["pyenv::checkout virtualenv ${user}"],
  }

  exec { "pyenv::shrc ${user}":
    command => "echo 'source ${pyenvrc}' >> ${shrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q pyenvrc ${shrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File["pyenv::pyenvrc ${user}"],
  }
}
