class realUvlayout {
  $users = [ 'username', 'username2', 'username3']
  file { "/usr/lib64/libGLEW.so.1.5":
    ensure => file,
    source => "puppet-master:///modules/realUvlayout/libGLEW.so.1.5",
  }
  $users.each | String $user| {
    file_line { 'Adding_env_vars':
      path => '/USERS/${user}/.mybashrc':
      line => '#adding uvlayout home and assorted vars \n export HEADUS_HOME=/Path/On/nfs/uvlayout/2.10.01 \n export PATH=$PATH:$HEADUS_HOME/bin \n  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HEADUS_HOME/lib'

    }
  }
}
