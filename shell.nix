with import <nixpkgs> {};
pkgs.mkShell {
  buildInputs = [
    bashInteractive
    (python38.withPackages (x: with x; [
      pip
      setuptools
    ]))
  ];

  shellHook = ''
    export PIP_PREFIX="$(pwd)/_build/pip_packages"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.8/site-packages:$PYTHONPATH" 
    unset SOURCE_DATE_EPOCH
    export PATH="$(pwd)/_build/pip_packages/bin:$PATH"

    pip install globus-cli
  '';
}