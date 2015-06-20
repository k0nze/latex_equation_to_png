#!/bin/bash

function syntax_msg {
    echo "SYNTAX:"
    echo "    equation_to_png.sh [OPTIONS] LATEX_CODE OUTPUT_FILE"
    echo ""
    echo "OPTIONS:"
    echo "    --help, -h: shows this help text"
    echo ""
    echo "LATEX_CODE:"
    echo '    LaTeX code without $..$, $$..$$ or \[\]'
    echo ""
    echo "OUTPUT_FILE:"
    echo "    path to output file (PNG)"
}

function random_string {
    cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

# TODO check if the following programs are available
# latex
# dvips 
# convert

# display help
if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then 
    syntax_msg
    exit 0
fi

LATEX_CODE=${1}
OUTPUT_FILE=${2}

if [ -z "${LATEX_CODE}" ]; then
    echo "ERROR: no LaTeX code was given"
    exit 1
fi

if [ -z "${OUTPUT_FILE}" ]; then
    echo "ERROR: no output file path was given"
    exit 1
fi

# determine path to this script
SCRIPT_DIR_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TEX_FILE_PATH="${SCRIPT_DIR_PATH}/equation.tex"

# create directory in tmp
TMP_DIR_PATH="/tmp/latex_equation_to_png.$(random_string)"

mkdir ${TMP_DIR_PATH}

# path to temporary tex file
TMP_TEX_FILE_PATH="${TMP_DIR_PATH}/equation.tex"

# create temporary tex file from template and insert given equation
while read -r LINE; do 
    if [ "${LINE}" == "REPLACE_WITH_LATEX_CODE" ]; then
        echo ${LATEX_CODE} >> ${TMP_TEX_FILE_PATH}
    else
        echo ${LINE} >> ${TMP_TEX_FILE_PATH}
    fi
done < ${TEX_FILE_PATH}

# compile temporary tex file
latex --output-directory=${TMP_DIR_PATH} ${TMP_TEX_FILE_PATH}

# check if compilation was successful
if [ "$?" -ne "0" ]; then
    echo "ERROR: latex could not process this equation"
    rm -r ${TMP_DIR_PATH}
    exit 1
fi

# create ps from dvi
dvips ${TMP_TEX_FILE_PATH%.*}.dvi -o ${TMP_TEX_FILE_PATH%.*}.ps

# create png from ps
convert -density 600 ${TMP_TEX_FILE_PATH%.*}.ps ${OUTPUT_FILE}

# remove directory in tmp
rm -r ${TMP_DIR_PATH}
