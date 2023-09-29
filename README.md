# libs


## Lib DPKG

### `dpkg_set_package_name`
This function sets the name of the package.

Example usage:

``` shellscript
dpkg_set_package_name "my_package"
```

> This function should be called before dpkg_make_package.

### `dpkg_set_package_version`
This function sets the version of the package.

Example usage:

``` shellscript
dpkg_set_package_version "1.0.0"
```

> This function should be called before dpkg_make_package.


### `dpkg_set_package_revision`
This function sets the revision of the package.

Example usage:

``` shellscript
dpkg_set_package_revision "1"
```

> This function should be called before dpkg_make_package.

### `dpkg_set_package_architecture`
This function sets the architecture of the package.

Example usage:

``` shellscript
dpkg_set_package_architecture "amd64"
```

> This function should be called before dpkg_make_package.

### `dpkg_make_package`

This function creates the package directory structure and sets the package filename based on the package name, version, revision, and architecture. It also removes any existing package directory with the same name.

Example usage:

```shellscript
dpkg_make_package
```

> This function should be called after all other package configuration functions have been called.


### `dpkg_add_file`

This function adds a file to the package. The file will be copied to the package directory structure.

Example usage:

```shellscript
dpkg_add_file "path/to/file" "desired/path/on/system"
```

> This function should be called after dpkg_make_package.

### `dpkg_add_symlink`

This function adds a symlink to the package. The symlink will be created in the package directory structure.

Example usage:

```shellscript
dpkg_add_symlink "path/to/file" "desired/path/on/system"
```

> This function should be called after dpkg_make_package.


### `dpkg_add_api`

This function adds an API to the package. The API will be copied to the package directory structure.

Example usage:

```shellscript
dpkg_add_api "path/to/api" "desired/path/on/system" "desired_api_name"
```

> This function should be called after dpkg_make_package.


### `dpkg_set_dependency`

This function sets a dependency for the package.

Example usage:

```shellscript
dpkg_set_dependency "dependency"
```

> This function should be called after dpkg_make_package.


### `dpkg_supersede`

This function supersedes or replaces another package.

Example usage:

```shellscript
dpkg_supersede "supersede"
```

> This function should be called after dpkg_make_package.

### `dpkg_finalize_package`

This function finalizes the package by adding the package name, maintainer, architecture, version, description, and dependencies to the control file, and then builds the package using `dpkg --build`.

Example usage:

```shellscript
dpkg_finalize_package
```

> This function should be called after all other package configuration functions have been called.




