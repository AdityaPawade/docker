ORIENTDB_SERVICES_WORKSPACE='~/orientdb/docker-volumes'
ORIENTDB_DOCKER_FOLDER="./infra"
BASE_DOCKER_FOLDER="./base"

OS_VERSION='wheezy'
JAVA_VERSION='8'

help:
	@echo "make {start|stop}" >&2

build_base_images:
	@echo "Building base images"
	cd ${BASE_DOCKER_FOLDER}; \
		OS_VERSION=${OS_VERSION} JAVA_VERSION=${JAVA_VERSION} \
		ORIENTDB_SERVICES_WORKSPACE=${ORIENTDB_SERVICES_WORKSPACE} docker-compose build

build_services_infra_images: build_base_images
	@echo "Building  services infra images"
	cd ${ORIENTDB_DOCKER_FOLDER}; \
    	OS_VERSION=${OS_VERSION} JAVA_VERSION=${JAVA_VERSION} \
    	ORIENTDB_SERVICES_WORKSPACE=${ORIENTDB_SERVICES_WORKSPACE} docker-compose build

stop:
	@echo "Stopping  services containers"
	@cd ${ORIENTDB_DOCKER_FOLDER}; \
		ORIENTDB_SERVICES_WORKSPACE=${ORIENTDB_SERVICES_WORKSPACE} docker-compose down --rmi local
	@echo "Deleting OrientDB ORIENTDB_SERVICES_WORKSPACE ${ORIENTDB_SERVICES_WORKSPACE}"
	@rm -rf ${ORIENTDB_SERVICES_WORKSPACE}

start: build_services_infra_images
	mkdir -p "${ORIENTDB_SERVICES_WORKSPACE}"
	echo "${ORIENTDB_SERVICES_WORKSPACE}"
	cd ${ORIENTDB_DOCKER_FOLDER}; \
		ORIENTDB_SERVICES_WORKSPACE=${ORIENTDB_SERVICES_WORKSPACE} docker-compose up
