### vStack NVME test suite

This is collection of test scripts targeted to validate bhyve nvmf device implementation based on SPDK.

The testcases are placed in the ./scripts directory and executed by runner.sh
script in the root directory. Also, there is ./nvme-cli-tests-runner directory,
with script needed for running python tests from nvme-cli (https://github.com/linux-nvme/nvme-cli).

Every testcase contain four functions:
- nvme_cli_passthru()
- nvme_cli_normal()
- nvme_control_passthru()
- nvme_control_normal() 

It is needed because nvme controlling commands could be executed on FreeBSD by two ways. One is FreeBSD native way using nvmecontrol (man 8 nvmecontrol), and other - linux way, using nvme cli (https://www.freshports.org/sysutils/nvme-cli/). Also, almost every controlling nvme command could be executed directly or thru passthru interface. The function should return error 127, if
there is no implementation, or nvme command cannot be executed by this way. It is accounted in the test results reporting.

See config.sh file to define nvme drives for testing.