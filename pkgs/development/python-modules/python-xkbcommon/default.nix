{ cffi
, buildPythonApplication
, fetchFromGitHub
, libxkbcommon
}:
buildPythonApplication rec {
  name = "python-xkbcommon-${version}";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "sde1000";
    repo = "python-xkbcommon";
    rev = "v${version}";
    sha256 = "gGBmQY28WjcPCQLokG/313vilQkRrxmnmPGX1IX8ZYo=";
  };
  nativeBuildInputs = [
    cffi
    libxkbcommon
  ];
  propagatedBuildInputs = nativeBuildInputs;
  preBuild = ''
        python ./xkbcommon/ffi_build.py
  '';

  doCheck = true;
}
