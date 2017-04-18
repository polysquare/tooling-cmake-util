def run(cont, util, shell, argv=None):
    py_cont = cont.fetch_and_import("setup/project/configure_python.py").run(cont, util, shell, util.language_version("python2"))
    with py_cont.activated(util):
        import os
        util.print_message(util.which("conan") + "\n")
        util.print_message(os.environ["PATH"]	)
