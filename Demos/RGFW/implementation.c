#define RGFW_IMPLEMENTATION
#define RGFW_EXPORT

/* Build the implementation of the RGFW library */
#include "RGFW.h"

#ifdef _WIN32
#include <windows.h>
#include <windef.h>

HINSTANCE win32_get_HINSTANCE(void) {
    return GetModuleHandleA(NULL);
}

HINSTANCE win32_get_HINSTANCE_from_HWND(void * hwndPtr) {
    return (HINSTANCE)GetWindowLongPtr(hwndPtr, GWLP_HINSTANCE);
}

#endif

