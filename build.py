import os
from pathlib import Path
from subprocess import run
from shutil import copytree
import argparse

repo_root = Path(os.path.realpath(__file__)).parent
sources_dir = repo_root / "sources"
recipes_dir = repo_root / "recipes"
patches_dir = repo_root / "patches"

parser = argparse.ArgumentParser()
parser.add_argument("pkg")
parser.add_argument("--repo", default=None)
parser.add_argument("--pkgrel", default=None)


def read_list(list_file):
    return set((recipes_dir / list_file).read_text().splitlines())


plain_change_list = read_list("plain-change.list")
plain_autoconf_list = read_list("plain-autoconf.list")
patch_list = read_list("patch.list")


def init_source(pkg):
    print("Initializing source for", pkg, "...")
    p = run(["bash", str(repo_root / "init-source.bash"), pkg],
            cwd=sources_dir, check=True)


def patch_source(pkg):
    if pkg in patch_list:
        print("Patching source for", pkg, "...")
        copytree(patches_dir / pkg, sources_dir / pkg, dirs_exist_ok=True)
        run(["patch", "-Np0", "-i", str(sources_dir / pkg / "pacman-for-android.patch")],
            cwd=str(sources_dir / pkg), check=True)
    else:
        print("No patch for", pkg)


def build(pkg, repo=None, pkgrel=None):
    print("Building", pkg, "...")
    init_source(pkg)
    patch_source(pkg)
    pkgbuild_path = sources_dir / pkg / "PKGBUILD"
    if pkg in plain_change_list:
        run(["bash", str(recipes_dir / "plain-change.bash"), pkgbuild_path],
            cwd=sources_dir, check=True)
    if pkg in plain_autoconf_list:
        run(["bash", str(recipes_dir / "plain-autoconf.bash"),
            pkgbuild_path], cwd=sources_dir, check=True)

    if pkgrel:
        run(["bash", str(recipes_dir / "change-pkgrel.bash"),
            pkg, pkgrel], cwd=sources_dir, check=True)

    run(["bash", str(recipes_dir / "fix-arch.bash"), pkg], check=True)
    run(["bash", str(repo_root / "adbuild"), pkg] +
        ([repo] if repo else []), cwd=sources_dir, check=True)


if __name__ == "__main__":
    args = parser.parse_args()
    build(args.pkg, args.repo, args.pkgrel)
