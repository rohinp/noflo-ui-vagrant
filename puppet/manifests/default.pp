Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'add-nodesource-repo':
	command => "curl -sL https://deb.nodesource.com/setup | sudo bash -",
}
exec { 'add-ubuntu-git-maintainers-repo':
	command => "add-apt-repository ppa:git-core/ppa",
}

class system-update {
	exec { 'apt-get update':
		command => 'apt-get update',
  }
}

class system-upgrade {
	exec { 'apt-get upgrade':
        	command => 'apt-get upgrade -y',
    }
}

class js_packages {
	package { "nodejs":
    		ensure => "latest"
    }
}
class tools_packages {
	package { "git":
		ensure => "latest"
	}
}
class bower_install {
	exec { 'install-bower':
		command => 'npm install -g bower',
	}
}

class grunt_install {
        exec { 'install-grunt':
                command => 'npm install -g grunt-cli',
        }
}

class clone_noflo {
	require tools_packages
	require grunt_install

	exec { 'git-clone-noflo':
		cwd => '/vagrant',
		command => 'git clone https://github.com/noflo/noflo-ui.git'
	}
}

class install_noflo {
	require clone_noflo

	exec { 'install-noflo':
		cwd => '/vagrant/noflo-ui',
		command => 'sudo npm install'
	}
}

class grunt_build {
	require install_noflo

	exec { 'grunt-build':
		cwd => '/vagrant/noflo-ui',
		command => 'sudo grunt build'
	}
}

class install_simple_server {
	require grunt_build

	exec { 'install-simple-server':
		cwd => '/vagrant/noflo-ui',
		command => 'sudo npm install simple-server'
	}
}


include system-update
include js_packages
include tools_packages
include bower_install
include grunt_install
include clone_noflo
include install_noflo
include grunt_build
include install_simple_server


