#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>

int main()
{
    // Spack user launches a test script test_install_mulituser_dummy.sh
    // that launches this suid executable
    // that runs the test_install_dummy.sh script
    // as service user 'installationtest'

    printf("install_multiuser_dummy: setting uid to 0\n");
    int status = setuid(0);
    assert(status == 0);

    char *pwd = getcwd(NULL, 1024);
    char command_buffer[256];
    sprintf(command_buffer, "/usr/sbin/runuser -l installationtest -c \". %s/test_0020_install_dummy.sh\"", pwd);
    printf("running command: %s\n", command_buffer);
    
    status = system(command_buffer);
    assert(status != -1); // -1 means the system call failed, otherwise it's $?
    printf("install_multiuser_dummy: install returned status %d\n", status);
    free(pwd);
    
    return status;
}
