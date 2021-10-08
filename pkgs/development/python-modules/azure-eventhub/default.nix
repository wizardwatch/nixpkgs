{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.6.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b2c8d37ac8cf1484da079532d3ad69a1da8bd78a237822159b72d6b05de4638d";
  };

  propagatedBuildInputs = [
    azure-core
    uamqp
  ];

  # too complicated to set up
  doCheck = false;

  pythonImportsCheck = [
    "azure.eventhub"
    "azure.eventhub.aio"
  ];

  meta = with lib; {
    description = "Microsoft Azure Event Hubs Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/eventhub/azure-eventhub";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
