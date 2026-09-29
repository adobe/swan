import unittest
from unittest.mock import patch

from dawn_builder import Arch, OS, TargetConfig, cmake_flags


class CMakeFlagsTests(unittest.TestCase):
    def test_linux_build_disables_dawn_cpp_modules(self) -> None:
        target_config = TargetConfig(
            os=OS.LINUX,
            arch=[Arch.X86_64],
        )

        flags = cmake_flags(target_config)

        self.assertIn("-DDAWN_SUPPORTS_CXX_MODULES=OFF", flags)

    def test_ios_build_passes_host_protoc_to_cmake(self) -> None:
        target_config = TargetConfig(
            os=OS.IPHONE,
            arch=[Arch.ARM64],
            sdk="iphoneos",
        )

        with patch("dawn_builder.find_sdk_path", return_value="/path/to/iphoneos.sdk"):
            with patch("dawn_builder.shutil.which", return_value="/opt/homebrew/bin/protoc"):
                flags = cmake_flags(target_config)

        self.assertIn("-DPROTOC_EXECUTABLE=/opt/homebrew/bin/protoc", flags)

    def test_ios_build_requires_host_protoc(self) -> None:
        target_config = TargetConfig(
            os=OS.IPHONE,
            arch=[Arch.ARM64],
            sdk="iphoneos",
        )

        with patch("dawn_builder.find_sdk_path", return_value="/path/to/iphoneos.sdk"):
            with patch("dawn_builder.shutil.which", return_value=None):
                with self.assertRaisesRegex(FileNotFoundError, "Host protoc"):
                    cmake_flags(target_config)


if __name__ == "__main__":
    unittest.main()
