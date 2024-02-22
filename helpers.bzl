"""Helper flags for nanobind build options."""

def sizeopts():
    return select({
        "@nanobind//:msvc_and_minsize": ["/Os"],
        "@nanobind//:nonmsvc_and_minsize": ["-Os"],
        "@nanobind//:without_sizeopts": [],
    })
