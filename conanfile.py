from conans import ConanFile
from conans.tools import download, unzip
import os

VERSION = "0.0.7"


class ToolingCMakeUtilConan(ConanFile):
    name = "tooling-cmake-util"
    version = os.environ.get("CONAN_VERSION_OVERRIDE", VERSION)
    generators = "cmake"
    requires = ("cmake-include-guard/master@smspillaz/cmake-include-guard",
                "cmake-unit/master@smspillaz/cmake-unit",
                "cmake-header-language/master@smspillaz/cmake-header-language")
    url = "http://github.com/polysquare/tooling-cmake-util"
    license = "MIT"

    def source(self):
        zip_name = "tooling-cmake-util.zip"
        download("https://github.com/polysquare/"
                 "tooling-cmake-util/archive/{version}.zip"
                 "".format(version="v" + VERSION),
                 zip_name)
        unzip(zip_name)
        os.unlink(zip_name)

    def package(self):
        self.copy(pattern="*.cmake",
                  dst="cmake/tooling-cmake-util",
                  src="tooling-cmake-util-" + VERSION,
                  keep_path=True)
