#! /bin/sh

# Kosei Moriyama <cou929@gmail.com>
#
# Monitor and notify update of Google JavaScript Style Guide
# (http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)
# in google-styleguide (http://code.google.com/p/google-styleguide/)
#
# Usage:
# 1. Set this script to checkouted google-styleguide dir
#    (ex. 
#    $ svn checkout http://google-styleguide.googlecode.com/svn/trunk/ google-styleguide-read-only
#    $ cp repo_monitor.sh google-styleguide-read-only
#    $ chmod 777 repo_monitor.sh
# 2. Set cron to run this script for certain interval
#    (ex. check repo everyday
#    0 0 * * * /path/to/repo_monitor.sh

WORK_DIR=/usr/local/share/google-styleguide-read-only/
TARGET="javascriptguide.xml"
SUBJECT="Google JavaScript Style Guide updates"
MAILTO="cou929@gmail.com"
REVFILE=${WORK_DIR}"current_revision"
KNOW_REV=0
TMP=tmpfile.$$

if [ -e ${REVFILE} ]; then
    KNOW_REV=`cat ${REVFILE}`
fi

cd ${WORK_DIR}
svn up
CUR_REV=`svn up | perl -ple 's/At revision ([0-9]+)\./$1/'`
PREV_REV=`expr ${CUR_REV} - 1`

if [ ${KNOW_REV} -ne ${CUR_REV} ]; then
    echo ${CUR_REV} > ${REVFILE}

    svn diff -r ${PREV_REV}:${CUR_REV} ${TARGET} > ${TMP}

    if [ -s ${TMP} ]; then
        cat ${TMP} | mail -s "${SUBJECT}" ${MAILTO}
    fi 

    rm -f ${TMP}
fi
