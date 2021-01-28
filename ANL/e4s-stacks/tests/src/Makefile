default:
	@echo
	@echo "The 'install' target here must be run as root, because it sets suid so that test can run as service user. "
	@echo

install: install_multiuser_dummy
	sudo chown root install_multiuser_dummy
	sudo chmod u+s install_multiuser_dummy
	mv install_multiuser_dummy ../bin

install_multiuser_dummy: install_multiuser_dummy.c
	gcc install_multiuser_dummy.c -o install_multiuser_dummy


