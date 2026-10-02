"""
Module extension for configuring nanobind_bazel.
Pins nanobind and robin-map to a specific version.
To override versions, use a `git_override` of nanobind-bazel,
and patch the version and integrity parameter of the `http_archive`s below.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

NANOBIND_BACKEND_WHEELS = {
    "cp310_linux_aarch64": (
        "https://files.pythonhosted.org/packages/2e/13/eebc40c9d083aa032e56a3ea1cf316b621e32de46b4c4daa3274ab5b1ed5/nanobind_backend-1.0.0-cp310-cp310-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-LMCV+vBNsbjAXkaFtrbtEVXWehSMuJLq1re2RXQYSw4=",
    ),
    "cp310_linux_riscv64": (
        "https://files.pythonhosted.org/packages/35/d2/590dd301da0d44a02ac297331e1e2a22934f851aa0b3d390156ecc6573fb/nanobind_backend-1.0.0-cp310-cp310-manylinux_2_39_riscv64.whl",
        "sha256-ptF8p0VwAPhIVWox9YhLIoanDbGyCqDMsJAkHy2v2D0=",
    ),
    "cp310_linux_x86_64": (
        "https://files.pythonhosted.org/packages/97/96/ee9bf6a053d8a2f505eab8cafc36ff8a3e4f928d0b01fd9befac579d537a/nanobind_backend-1.0.0-cp310-cp310-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-t+olxLaaM36uQ3fgxT8KAA39mWv+YTA7wDmW6LK/VzU=",
    ),
    "cp310_macos_aarch64": (
        "https://files.pythonhosted.org/packages/2c/7e/ef67e5cfc1436fb9759797fdd5fb68062d1d5cf50e36182c208749870d06/nanobind_backend-1.0.0-cp310-cp310-macosx_11_0_arm64.whl",
        "sha256-KUZmf7jMe7tS0BUcCQVAV2pSjkjc19G+vgB2iOcPil0=",
    ),
    "cp310_macos_x86_64": (
        "https://files.pythonhosted.org/packages/fe/23/e892b9c91154b16987ebc7efd795b3a23e244e8fba3ed071f9ac84224c3b/nanobind_backend-1.0.0-cp310-cp310-macosx_10_14_x86_64.whl",
        "sha256-4JbZdq39TSlQCV5AE0gy2TJeYrGAxlSBdJlvINRNDoI=",
    ),
    "cp310_windows_x86_64": (
        "https://files.pythonhosted.org/packages/f8/74/1cd06a4ab1fbb03aaba84f27d2536c925a0c87d6873fc794c0258de45264/nanobind_backend-1.0.0-cp310-cp310-win_amd64.whl",
        "sha256-4n40y3ZNDbsHMZ4+lWvj4IOS5V8ed4yCPy85USRr/Uw=",
    ),
    "cp311_linux_aarch64": (
        "https://files.pythonhosted.org/packages/b3/14/40f0a465df491562debf55044bcfc728dca7cb8e3ef76f532aa8f75e775b/nanobind_backend-1.0.0-cp311-cp311-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-/fQel8+58UnImzI7eFC9ncYxbR15rfmQgVEbmh0IWLE=",
    ),
    "cp311_linux_riscv64": (
        "https://files.pythonhosted.org/packages/49/77/45d11f991aa78e8dfaac490c6330e38912d414b60a6b624024e8eaa4cadb/nanobind_backend-1.0.0-cp311-cp311-manylinux_2_39_riscv64.whl",
        "sha256-137K0NS4Umhl9r7HzXdgPGhu9ltXzH7IF5WzpGjboPE=",
    ),
    "cp311_linux_x86_64": (
        "https://files.pythonhosted.org/packages/5f/9a/0db4d9982ac708b6c532ca6ea2a523d5c85a25f7fc288558c4d6fad725b0/nanobind_backend-1.0.0-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-M73sDaL3hmnVyVvVRv8rt3RNr6Q6Frtysu7N+D2MOzo=",
    ),
    "cp311_macos_aarch64": (
        "https://files.pythonhosted.org/packages/a8/65/c3ff5ef09109a163a3cbe8a69250ae7c4b0b4d8df79b1cb447d03747529f/nanobind_backend-1.0.0-cp311-cp311-macosx_11_0_arm64.whl",
        "sha256-icWC+D1JG6AaoaWtOe1sWb3q1n7DuMiLKIt+S2usGN8=",
    ),
    "cp311_macos_x86_64": (
        "https://files.pythonhosted.org/packages/76/49/a4c01de9c358b5749560a5415b899a8b57399381e5c8ae64962381302a59/nanobind_backend-1.0.0-cp311-cp311-macosx_10_14_x86_64.whl",
        "sha256-sgs+S7tnKYf51l5S8YKSmVicHM8FAjYIeYRqki6cse0=",
    ),
    "cp311_windows_aarch64": (
        "https://files.pythonhosted.org/packages/24/bb/fbaa64393f5ed253de5879e8d30477d05f53a3c2b106b9db4f33db7da310/nanobind_backend-1.0.0-cp311-cp311-win_arm64.whl",
        "sha256-3BmQVsvVNMUxeJlTmjYkWqFLzmuK/UjCF+V4skY+BZQ=",
    ),
    "cp311_windows_x86_64": (
        "https://files.pythonhosted.org/packages/d9/22/8a2576123da22743a1ca6b683e2e1a046990dd75ab3f70c21c0c8690d936/nanobind_backend-1.0.0-cp311-cp311-win_amd64.whl",
        "sha256-aRvoktzWtLExfWKLSb8+aIRw9PknrDFtyiM+4Z+rfs0=",
    ),
    "cp312_linux_aarch64": (
        "https://files.pythonhosted.org/packages/a3/3b/806d3346ae8175746853b204efd59a4ad8bbddf91d48d03f4eac48d15245/nanobind_backend-1.0.0-cp312-cp312-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-SkJQP2XNWV+Xox8k0hxt29AX/8uAhibQE05HXg2yXz0=",
    ),
    "cp312_linux_riscv64": (
        "https://files.pythonhosted.org/packages/18/bf/2f6dbcedcca065c20b73346f037d69d78fdb545c9abbf7ad8b27da7890c5/nanobind_backend-1.0.0-cp312-cp312-manylinux_2_39_riscv64.whl",
        "sha256-ANrcz6ktD56sCxh3/cP9mdLrsaZR++RNr/NloXO9L6o=",
    ),
    "cp312_linux_x86_64": (
        "https://files.pythonhosted.org/packages/b9/2c/7fb13ecb1e8c0c268e26c6bc44be4a7f51996b2a3c006749ce6fc4fd7da2/nanobind_backend-1.0.0-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-aqmGQFDMX9H/WdH5t5dA76J4UV7tJ6+EjvrgcSXAKbg=",
    ),
    "cp312_macos_aarch64": (
        "https://files.pythonhosted.org/packages/bc/3a/40e9ef3133573dddf32f7dcaf1bc7d4f459ecb632b2274c7a619fbfa40ea/nanobind_backend-1.0.0-cp312-cp312-macosx_11_0_arm64.whl",
        "sha256-3KiZnk6HpOOeFixVtw85/hiCkTxNfeGtq4HPgruMua0=",
    ),
    "cp312_macos_x86_64": (
        "https://files.pythonhosted.org/packages/b8/57/f02cc977a0ba1ddf2a41ebad61bcf2fbfd905aef7753082d9f39389a13e1/nanobind_backend-1.0.0-cp312-cp312-macosx_10_14_x86_64.whl",
        "sha256-n9kUWxqo6beAKTCKc+Gt6UNp1yUMgmeDZVIQ0YAPFJM=",
    ),
    "cp312_windows_aarch64": (
        "https://files.pythonhosted.org/packages/7a/45/851847d5246c0c47dbebe473ecfbb0ed44a41fae9ef7e2ec73cd7c8975a3/nanobind_backend-1.0.0-cp312-cp312-win_arm64.whl",
        "sha256-ofbmMgruSV5crZM9Zx6dYO5C9L9GCTDvev7RkSQ6pzM=",
    ),
    "cp312_windows_x86_64": (
        "https://files.pythonhosted.org/packages/7f/da/f6af805e0737652d4b6aa2e51e3ec1485d906e77ee9389b126adbb9f9644/nanobind_backend-1.0.0-cp312-cp312-win_amd64.whl",
        "sha256-mxUC4/FgNY/v+S9gpjThmMdnVPUKYP2s2ai13Mvl2dA=",
    ),
    "cp313_linux_aarch64": (
        "https://files.pythonhosted.org/packages/24/a1/97ffb303def8e5a4e48694b01d58477899392468295e8af5c60fdae5f035/nanobind_backend-1.0.0-cp313-cp313-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-jd8Bj8YqK9UenXzGR3r3rhPMwNtpt3XWfYN7p+C8QbQ=",
    ),
    "cp313_linux_riscv64": (
        "https://files.pythonhosted.org/packages/2c/01/7bb71f0a2566cb398d6877e3540307c3d0e684797001eb1128c2c3732a52/nanobind_backend-1.0.0-cp313-cp313-manylinux_2_39_riscv64.whl",
        "sha256-NqEWRxw8oLbNOvHh+i44xSCGotLa8AuG+QqZ2l793lM=",
    ),
    "cp313_linux_x86_64": (
        "https://files.pythonhosted.org/packages/c0/3e/0a2143308fd413ae10da3fb8732e9d2fc87de4605a1126d304ffe9f63414/nanobind_backend-1.0.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-3ix47UuI72xZqDXuvn9ekatoafF/kVphx9TuwkoeK4U=",
    ),
    "cp313_macos_aarch64": (
        "https://files.pythonhosted.org/packages/18/c2/d59e5b6af43e45088c18895035e053c4585bce7d1bde9679368ef5b960e0/nanobind_backend-1.0.0-cp313-cp313-macosx_11_0_arm64.whl",
        "sha256-KKTDl9bTbftxKsurgXwCrS+GWKhfsdu65zhWidKNIOk=",
    ),
    "cp313_macos_x86_64": (
        "https://files.pythonhosted.org/packages/06/eb/1c4f3e1fcc41093e321b1c4eb7ca79f628a36057496398bb9fba4d97e417/nanobind_backend-1.0.0-cp313-cp313-macosx_10_14_x86_64.whl",
        "sha256-pt16Zvt0FtYr5XfUHWRHihh9nzbQiXWVVWmLsIrdwsM=",
    ),
    "cp313_windows_aarch64": (
        "https://files.pythonhosted.org/packages/03/11/6c515cac31f723d2ce2c3155de4343a3ccf612025171cde25d48290c3680/nanobind_backend-1.0.0-cp313-cp313-win_arm64.whl",
        "sha256-a3wxQD5vOf1wQ1nOSgaH2JSp/6Z4E9pqVMbQ62/ek6o=",
    ),
    "cp313_windows_x86_64": (
        "https://files.pythonhosted.org/packages/90/49/8038eedfd35433968e638081ca4eb6881869e517f766beff0f095387dc9a/nanobind_backend-1.0.0-cp313-cp313-win_amd64.whl",
        "sha256-kVxv9M6SWEzd4YokzF1zDwSnDC8mvAvE25A8pUBD64Y=",
    ),
    "cp314_linux_aarch64": (
        "https://files.pythonhosted.org/packages/08/08/fecefa8c4e5774222b2ed1b715822bca5c9bfb5623fef9be7cc9133df18c/nanobind_backend-1.0.0-cp314-cp314-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-kmuh5+Ervz9wH3ogDogBxfm9BboiRJYmkvyvvTK4oNI=",
    ),
    "cp314_linux_riscv64": (
        "https://files.pythonhosted.org/packages/37/fe/69f69fbcd6d4e6cee3e27e65a2b10e354da8adfd0d88a87c4c33a845864f/nanobind_backend-1.0.0-cp314-cp314-manylinux_2_39_riscv64.whl",
        "sha256-zpPybaY+qiRynSFPpmaVJSk9deVvOU8pgIOc1lp10uU=",
    ),
    "cp314_linux_x86_64": (
        "https://files.pythonhosted.org/packages/fc/65/8073c078a91e2fed8c54154f6a0b1d39e362c0ab5ffa7cb93c73f87c9954/nanobind_backend-1.0.0-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-pCotWU8i5onxXL299L8UaO96gofaQYQlFcHMg2ofLew=",
    ),
    "cp314_macos_aarch64": (
        "https://files.pythonhosted.org/packages/8f/36/7f79710b96ba643c91db149f7ba1b454124cf2cf97e379ef6c3529d97dd0/nanobind_backend-1.0.0-cp314-cp314-macosx_11_0_arm64.whl",
        "sha256-V00QS/YyJxHl21XtSUCSid+VgujB/SovLWQ9ITZCjhM=",
    ),
    "cp314_macos_x86_64": (
        "https://files.pythonhosted.org/packages/33/82/474e530e562a2c98db0dbd35cc2bc08500895be7cab6b13c5c990c09a650/nanobind_backend-1.0.0-cp314-cp314-macosx_10_15_x86_64.whl",
        "sha256-BKNcc5Xa65oz9oAco9HhHgOEcCriK44+JR759qSlTBA=",
    ),
    "cp314_windows_aarch64": (
        "https://files.pythonhosted.org/packages/56/f2/7a44d3b12d4a876c123445fe6f4971eff1260c6f7660ee00e261cdbe2770/nanobind_backend-1.0.0-cp314-cp314-win_arm64.whl",
        "sha256-Hl+CF4h9HYPMvh5hw30VAquVH+9GagbfKrsRYeJG73k=",
    ),
    "cp314_windows_x86_64": (
        "https://files.pythonhosted.org/packages/89/3e/e33c10a7b0a728e83d492673612146ed7cd47c5d28c242969b4296cb6265/nanobind_backend-1.0.0-cp314-cp314-win_amd64.whl",
        "sha256-sOq/ZxyR/c1qYdIXeqQ0cxaARCqiMX3lSs+r6sSkzAY=",
    ),
    "cp315_linux_aarch64": (
        "https://files.pythonhosted.org/packages/65/29/101f4ebf5d0455ddab57785d8a341c1bd25d248e0c444ef9cb6ce85df9bb/nanobind_backend-1.0.0-cp315-cp315-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-2aFcgVXEZQZv30OiWJIjzUH0poj1IEb1ntze0HkKitM=",
    ),
    "cp315_linux_riscv64": (
        "https://files.pythonhosted.org/packages/cd/68/698c970f8df703be42720b96678ce0de08536938c95b3ab551e64a33f9ca/nanobind_backend-1.0.0-cp315-cp315-manylinux_2_39_riscv64.whl",
        "sha256-+sleZ7qRxjnFIpg4jSJZXB2RKgmmcdR5PI0WcRoN0b4=",
    ),
    "cp315_linux_x86_64": (
        "https://files.pythonhosted.org/packages/34/e1/5630f4e2297fb03749551592e9850ba45d498952a135d3065b49bc68e603/nanobind_backend-1.0.0-cp315-cp315-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-lXTMYkuf/y6PWUYhFCJHaXfkP2t5a4PhQ7KJ7LcN9M8=",
    ),
    "cp315_macos_aarch64": (
        "https://files.pythonhosted.org/packages/f3/6b/441ddd77a34b013350289c2fc99279d76403d45ab6cfdd6ea60be3e09a75/nanobind_backend-1.0.0-cp315-cp315-macosx_11_0_arm64.whl",
        "sha256-enx2/JWOt79LVFTZwDbx6S+LQGNDx7e39OUzAnGP/uY=",
    ),
    "cp315_macos_x86_64": (
        "https://files.pythonhosted.org/packages/a6/19/3104f9a204271cd57192bdf50577980c030ad3e53dd6ae6fe1aef9bbb5d8/nanobind_backend-1.0.0-cp315-cp315-macosx_10_15_x86_64.whl",
        "sha256-SBbPb5mLDCQ1qmQ996XFlJIgJ3jJbldeVdqALlHHVGE=",
    ),
    "cp315_windows_aarch64": (
        "https://files.pythonhosted.org/packages/a2/14/cd5789bb09cb3a82b9e85b5164f2b4d7cff2ca6b861d4f89a7df9ae8d207/nanobind_backend-1.0.0-cp315-cp315-win_arm64.whl",
        "sha256-p6l6Eyb6LXDgE7evdpMFeWBHoB3EVn9fkNdpxqLiNE0=",
    ),
    "cp315_windows_x86_64": (
        "https://files.pythonhosted.org/packages/9f/29/6dd73fdcd3deed710d0dc3b2a4a86ad491450dbc2cd58018a9091a4164f1/nanobind_backend-1.0.0-cp315-cp315-win_amd64.whl",
        "sha256-SuAhStZwi4AB2C8d1sMCqrqWJ9gaoFc+/IlqO5D5W84=",
    ),
    "cp315t_linux_aarch64": (
        "https://files.pythonhosted.org/packages/9b/29/a953f8be0c7b69509793d179f8f709b2c5d301bf65089bb3d87afa859f25/nanobind_backend-1.0.0-cp315-cp315t-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl",
        "sha256-qD8chqosfaM85KjfQwTTTWNkM1ssRVpJCYMFlHHiHE0=",
    ),
    "cp315t_linux_riscv64": (
        "https://files.pythonhosted.org/packages/6a/d0/7e56cf0b6faae40d23ec7b5c4d90ad74480038bc99dd9f8b05c58dc70726/nanobind_backend-1.0.0-cp315-cp315t-manylinux_2_39_riscv64.whl",
        "sha256-mDqur2XmHd/xJaPupGNnXTItmYFRD29uRi5rz8kV3KY=",
    ),
    "cp315t_linux_x86_64": (
        "https://files.pythonhosted.org/packages/00/d4/cce583c8177b061a3ee82c23da857f64975c1f28bdd614ecf7beda52f38a/nanobind_backend-1.0.0-cp315-cp315t-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl",
        "sha256-bqP+BDQQQLCURMyUb1zTkUUpCy3juQyphosbWcx1wj4=",
    ),
    "cp315t_macos_aarch64": (
        "https://files.pythonhosted.org/packages/36/e8/526799c68933550776b2002a0240ff770474d11a527962541b212f9d23fc/nanobind_backend-1.0.0-cp315-cp315t-macosx_11_0_arm64.whl",
        "sha256-F6ndxswJbXExUfu6q+Qdlg0dWWwOBGq80rF8bWVlxEM=",
    ),
    "cp315t_macos_x86_64": (
        "https://files.pythonhosted.org/packages/1d/60/7754c00b60994a790574ec6190aeafeb8878e7c72c2c1877b84ebc911451/nanobind_backend-1.0.0-cp315-cp315t-macosx_10_15_x86_64.whl",
        "sha256-2FgczF8ACna0ME+cjE7p5gSZqdlQLm4OiFwWBtayn2A=",
    ),
    "cp315t_windows_aarch64": (
        "https://files.pythonhosted.org/packages/8c/db/badc51c6b13ccb0f7a6ef88e8be014193cfe727f0849eaafa28489a848a2/nanobind_backend-1.0.0-cp315-cp315t-win_arm64.whl",
        "sha256-iXVCJHmxRc5G1NebT8A9v6tAJURwRoqZ6kFwkLsc5GA=",
    ),
    "cp315t_windows_x86_64": (
        "https://files.pythonhosted.org/packages/f4/cf/941d624be0dd41f4bb139fe74d489d83845909dadc9f19fe7d4da5d5c3d1/nanobind_backend-1.0.0-cp315-cp315t-win_amd64.whl",
        "sha256-KkLNUJwYicvM3PiiPcNzPEt+I4iXOsQpLbCUV24+J9A=",
    ),
}

def _internal_configure_extension_impl(_):
    nanobind_version = "3.0.1"
    http_archive(
        name = "nanobind",
        build_file = "//:nanobind.BUILD",
        strip_prefix = "nanobind-%s" % nanobind_version,
        integrity = "sha256-NN7XzyKS8IqSxFSQoJXnYzSld1G7rgOoyDJBgDvxliM=",
        urls = ["https://github.com/wjakob/nanobind/archive/refs/tags/v%s.tar.gz" % nanobind_version],
    )

    typing_extensions_version = "4.15.0"
    http_archive(
        name = "pypi__typing_extensions",
        build_file = "//:typing_extensions.BUILD",
        strip_prefix = "typing_extensions-%s" % typing_extensions_version,
        integrity = "sha256-DOpI0XPMEvoo7KvDuDfqPPbzjG0RNvhcuq9ZiYSGFGY=",
        urls = ["https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-%s.tar.gz" % typing_extensions_version],
    )

    for key, (url, integrity) in NANOBIND_BACKEND_WHEELS.items():
        http_archive(
            name = "pypi__nanobind_backend_" + key,
            build_file = "//:nanobind_backend.BUILD",
            integrity = integrity,
            type = "zip",
            urls = [url],
        )

internal_configure_extension = module_extension(implementation = _internal_configure_extension_impl)
