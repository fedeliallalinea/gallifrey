#!/bin/bash
[ ! -d "${HOME}"/.tmm ] && mkdir "${HOME}"/.tmm
cd "${HOME}"/.tmm
java \
	-Djava.net.preferIPv4Stack=true \
	-Dappbase=http://www.tinymediamanager.org/ \
	-Dtmm.datafolder="${HOME}"/.tmm/data \
	-splash:/opt/tinyMediaManager/splashscreen.png \
	-cp /opt/tinyMediaManager/tmm.jar:/opt/tinyMediaManager/lib/*:/opt/tinyMediaManager/plugins/* \
	org.tinymediamanager.TinyMediaManager
