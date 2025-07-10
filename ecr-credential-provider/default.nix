{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ecr-credential-provider";
  version = "1.33.2";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "cloud-provider-aws";
    rev = "af0e606f271a47809c50e0e84a7249f1d188f229";
    hash = "sha256-mjL9y+ar/iNhukhIRd+Dpt17N8/s98Xbycdd5hC1NCo=";
  };

  vendorHash = "sha256-eqKdpWv2NmxJXuMreovG7e4YB/8HHAXMdPXqwrtsbXY=";

  subPackages = ["cmd/ecr-credential-provider"];

  ldflags = [
    "-w"
    "-s"
    "-X k8s.io/component-base/version.gitVersion=v${version}"
  ];

  doCheck = false;

  meta = {
    mainProgram = "ecr-credential-provider";
  };
}
