#!/usr/bin/env bash


_dpkg_make_control_file (){
    # check if the control file exists, make it if not
    if [ ! -f "${PACKAGE_TMP_DIR}"/DEBIAN/control ]; then
        touch "${PACKAGE_TMP_DIR}"/DEBIAN/control
    fi
}

_dpkg_add_package_name (){
    echo "Package: ${PACKAGE_NAME}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

_dpkg_add_maintainer (){
    local MAINTAINER_EMAIL
    local MAINTAINER_NAME

    MAINTAINER_EMAIL=$(git config user.email)
    MAINTAINER_NAME=$(git config user.name)

    echo "Maintainer: ${MAINTAINER_NAME} <${MAINTAINER_EMAIL}>" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

_dpkg_add_architecture (){
    echo "Architecture: ${ARCH}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

_dpkg_add_version (){
    echo "Version: ${VERSION}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

_dpkg_add_description (){
    echo "Description: ${DESCRIPTION}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

_unset_all(){
    unset PACKAGE_NAME
    unset VERSION
    unset REVISION
    unset ARCH
    unset DESCRIPTION
    unset PACKAGE_TMP_DIR
    unset PACKAGE_FILENAME
    unset DEPENDENCIES
    unset PACKAGE_TMP_DIR
}

_dpkg_add_dependencies (){
    echo "Depends: ${DEPENDENCIES}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

dpkg_make_package (){
    PACKAGE_FILENAME="${PACKAGE_NAME}"-"${VERSION}"-r"${REVISION}"-"${ARCH}"
    PACKAGE_TMP_DIR="${TMPDIR}""${PACKAGE_FILENAME}"
    rm -rf "${PACKAGE_TMP_DIR}"
    mkdir -p "${PACKAGE_TMP_DIR}"/DEBIAN
}

dpkg_set_package_name (){
    PACKAGE_NAME=$1
}

dpkg_set_version (){
    VERSION=$1
}

dpkg_set_revision (){
    REVISION=$1
}

dpkg_set_architecture (){
    ARCH=$1
}

dpkg_set_description (){
    DESCRIPTION=$1
}

dpkg_add_file (){
    local SRC=$1
    local DST=$2
    echo "Adding 'file ${SRC} -> ${DST}'"
    cp "${SRC}" "${PACKAGE_TMP_DIR}"/"${DST}"
}

dpkg_add_symlink (){
    local SRC=$1
    local DST=$2
    echo "Adding symlink '${SRC} -> ${DST}'"
    mkdir -p "${PACKAGE_TMP_DIR}"/"$(dirname "${DST}")"
    ln -sF "${SRC}" "${PACKAGE_TMP_DIR}"/"${DST}"
}

dpkg_add_api (){
    local SRC=$1
    local DST=$2
    local API=$3

    echo "${API}"
    dpkg_add_file "${SRC}" "${DST}"
    dpkg_add_symlink "${DST}" "${API}"
}

dpkg_set_dependency (){
    local DEPENDS=$1

    #check if DEPENDENCIES exists, if not, create it
    if [ -z "${DEPENDENCIES}" ]; then
        DEPENDENCIES="${DEPENDS}"
    else
        DEPENDENCIES="${DEPENDENCIES}, ${DEPENDS}"
    fi
}

dpkg_supersedes () {
    local SUPERSEDES=$1

    echo "Replaces: ${SUPERSEDES}" >> "${PACKAGE_TMP_DIR}"/DEBIAN/control
}

dpkg_add_maintainer_script () {
    local script=$1

    local script_name
    script_name=$(basename "${script}")
    cp "${script}" "${PACKAGE_TMP_DIR}"/DEBIAN/"${script_name}"
    chmod +x "${PACKAGE_TMP_DIR}"/DEBIAN/"${script_name}"
}

dpkg_finalize_package (){
    _dpkg_make_control_file
    _dpkg_add_package_name
    _dpkg_add_maintainer
    _dpkg_add_architecture
    _dpkg_add_version
    _dpkg_add_description
    _dpkg_add_dependencies

    cat "${PACKAGE_TMP_DIR}"/DEBIAN/control
    # build the package
    dpkg --build "${PACKAGE_TMP_DIR}"
    # move the package to the current directory
    mv "${PACKAGE_TMP_DIR}".deb "${PACKAGE_FILENAME}".deb
    rm -rf "${PACKAGE_NAME}"
    _unset_all
}


_unset_all
