#!/bin/sh

# script to update specified zone and zonefile
#
#
# Copyright 2022 Michael Graves <mg@brainfat.net>
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.
# 
#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
# 
#     3. Neither the name of the copyright holder nor the names of its
#        contributors may be used to endorse or promote products derived from
#        this software without specific prior written permission.
# 
#     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
#     TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#     A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#     HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#     LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
#     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#     ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#     OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
#     OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#     SUCH DAMAGE.

# Zone format: nsd, unbound
ZFMT="unbound"
IPAMCTL="/usr/local/bin/ipamctl"
UNB_CHK="/usr/sbin/unbound-checkconf"
NSD_CHK="/usr/sbin/nsd-checkzone"
DFMT="%Y%m%d-%H%M%S"

if [ $# -lt 2 ]; then
	echo "missing arguments"
	echo "update_zone.sh domain zonefile"
	exit 1
fi

dom=$1
zfil=$2

if [ ! -f ${zfil} ]; then
	echo "zone file ${zfil} missing"
	exit 1
fi

TS=$(date +"$DFMT")

$IPAMCTL export domain $dom ${ZFMT} > ${zfil}.new
if [ $? -ne 0 ]; then
	rm -f ${zfil}.new
	echo "Error exporting zone to file"
	exit 1
fi

if [ ! -s ${zfil}.new ]; then
	rm -f ${zfil}.new
	echo "No data returned"
	exit 1
fi

mv ${zfil} ${zfil}_${TS}
mv ${zfil}.new ${zfil}

revert=0
case ${ZFMT} in
	"unbound")
		${UNB_CHK}
		if [ $? -ne 0 ]; then
			echo "error with new zone. reverting"
			echo "check examin file ${zfil}.error"
			revert=1
		fi
		;;
	"nsd")
		${NSD_CHK} -p ${dom} ${zfil}
		if [ $? -ne 0 ]; then
			echo "error with new zone. reverting"
			echo "check examin file ${zfil}.error"
			revert=1
		fi
		;;
	"*")
		echo "unknown zone format cannot test"
		revert=1
		;;
esac

if [ ${revert} -eq 1 ]; then
	echo "reverting..."
	mv ${zfil} ${zfil}.error
	mv ${zfil}_${TS} ${zfil}
	exit 1
fi

exit 0

