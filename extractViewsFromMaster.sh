#!/usr/bin/env bash
#

export SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )";
export CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"   && pwd )
export SCRIPT_NAME=$( basename ${0#-} );
export THIS_SCRIPT=$( basename ${BASH_SOURCE} )

# echo -e "SCRIPT_DIR ${SCRIPT_DIR}";
# echo -e "CURR_SCRIPT_DIR ${CURR_SCRIPT_DIR}";
# echo -e "SCRIPT_NAME ${SCRIPT_NAME}";
# echo -e "THIS_SCRIPT ${THIS_SCRIPT}";

source ${CURR_SCRIPT_DIR}/utils.sh;

export TARGET_FILE_NAME="views_export.sql";
export TARGET_FILE=${TMP_DIR}/${TARGET_FILE_NAME};

echo -e "Deleting target file ::  ${TARGET_FILE}";
sudo -A rm -f ${TARGET_FILE}

mysql -A -e "SELECT CONCAT('CREATE OR REPLACE VIEW \`', TABLE_NAME, '\` AS ', VIEW_DEFINITION) AS create_view_statement FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = '_091b776d72ba8e16' INTO OUTFILE '${TARGET_FILE}';"
# mysql -A -e "SELECT TABLE_NAME AS create_view_statement FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = '_091b776d72ba8e16';"

echo -e "Views creation script written to target file ::  ${TARGET_FILE}";
