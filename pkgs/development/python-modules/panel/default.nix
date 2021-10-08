{ lib
, buildPythonPackage
, fetchPypi
, bleach
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, testpath
, tqdm
, callPackage
}:

let
  node = callPackage ./node { };
in
buildPythonPackage rec {
  pname = "panel";
  version = "0.12.4";

  # Don't forget to also update the node packages
  # 1. retrieve the package.json file
  # 2. nix shell nixpkgs#nodePackages.node2nix
  # 3. node2nix
  src = fetchPypi {
    inherit pname version;
    sha256 = "e1dbe5c06d3f87de139b531b0eec4c5554eab7629230ab1455e078e6d1c5af89";
  };

  # Since 0.10.0 panel attempts to fetch from the web.
  # We avoid this:
  # - we use node2nix to fetch assets
  # - we disable bundling (which also tries to fetch assets)
  # Downside of disabling bundling is that in an airgapped environment
  # one may miss assets.
  # https://github.com/holoviz/panel/issues/1819
  preBuild = ''
    substituteInPlace setup.py --replace "bundle_resources()" ""
    pushd panel
    ln -s ${node.nodeDependencies}/lib/node_modules
    export PATH="${node.nodeDependencies}/bin:$PATH"
    popd
  '';

  propagatedBuildInputs = [
    bleach
    bokeh
    param
    pyviz-comms
    markdown
    pyct
    testpath
    tqdm
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  passthru = {
    inherit node; # For convenience
  };

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = "https://pyviz.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
