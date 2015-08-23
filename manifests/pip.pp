define pyenv::pip(
  $user,
  $group = $user,
  $virtual_env_name,
  $package,
) {

  $home = User[$user]["home"]
  $bin_path = "${home}/.pyenv/versions/${virtual_env_name}/bin"
  exec { "pip install ${package} to ${virtual_env_name}":
    user    => $user,
    path    => [$bin_path, "/bin"],
    cwd     => $home,
    unless  => "pip list | grep -q ${package}",
    command => "pip install uwsgi",
  }
}
