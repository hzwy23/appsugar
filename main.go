package main

import (
	"github.com/hzwy23/apps/mas/ca"
	"github.com/hzwy23/apps/mas/common"
	"github.com/hzwy23/apps/mas/ftp"
	"github.com/hzwy23/auth-core"
)

func main() {
	auth_core.AppRegister("auth", auth_core.Register)
	auth_core.AppRegister("ca", ca.Register)
	auth_core.AppRegister("common", common.Register)
	auth_core.AppRegister("ftp", ftp.Register)
	auth_core.Bootstrap()
}
