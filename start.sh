# define required variables
required_vars="$required_vars OS_USERNAME"
required_vars="$required_vars OS_PASSWORD"
required_vars="$required_vars OS_TENANT_NAME"
required_vars="$required_vars OS_AUTH_URL"

# read all OpenStack RC files
for rc in *-openstackrc.sh; do
	source $rc
done

# ask variables
for var in ${required_vars}; do
	if [ -z "${!var}" ]; then
		echo "Please enter ${var}"
		read -r ${var}
		export ${var}=${!var}
	fi
done

# invoke proxy script
python openstack_proxy.py &

# start Minecraft C++ server
cd world/
../cuberite_server/Cuberite
