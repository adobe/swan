# Dawn Wrappers

The Dawn C API, even when transformed by our apinotes file, is very C-like. It makes heavy
use of unsafe pointers. In order to make a safer and more Swift-like API for Dawn, we
generate wrappers for some of the Dawn types, such as most of the structs and string
views.

This plugin handles the generation of wrapper code at build time.
