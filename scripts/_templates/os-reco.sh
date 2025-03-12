# OS specific support (must be 'true' or 'false')
cygwin=false;
darwin=false;
solaris=false;
freebsd=false;
case "$(uname)" in
    CYGWIN*)
        cygwin=true
        ;;
    Darwin*)
        darwin=true
        ;;
    SunOS*)
        solaris=true
        ;;
    FreeBSD*)
        freebsd=true
esac

# Infer platform
function infer_platform() {
	local kernel
	local machine

	kernel="$(uname -s)"
	machine="$(uname -m)"

	case $kernel in
	Linux)
	  case $machine in
	  i686)
		echo "linuxx32"
		;;
	  x86_64)
		echo "linuxx64"
		;;
	  armv6l)
		echo "linuxarm32hf"
		;;
	  armv7l)
		echo "linuxarm32hf"
		;;
	  armv8l)
		echo "linuxarm32hf"
		;;
	  aarch64)
		echo "linuxarm64"
		;;
	  *)
	  	echo "linuxexotic"
	  	;;
	  esac
	  ;;
	Darwin)
	  case $machine in
	  x86_64)
		echo "darwinx64"
		;;
	  arm64)
		echo "darwinarm64"
		;;
	  *)
	  	echo "darwinx64"
	  	;;
	  esac
	  ;;
	MSYS*|MINGW*)
	  case $machine in
	  x86_64)
		echo "windowsx64"
		;;
	  *)
	  	echo "windowsexotic"
	  	;;
	  esac
	  ;;
	*)
	  echo "exotic"
	esac
}
