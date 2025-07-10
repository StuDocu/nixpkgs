{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation rec {
  pname = "selenium-server";
  version = "4.18.0";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/selenium/releases/download/selenium-${version}/selenium-server-${version}.jar";
    sha256 = "sha256-6mRqDO23dxUW5+RWbeg0GSOSXpGjhMwqQ6euep4VD54=";
  };

  dontUnpack = true;

  nativeBuildInputs = [makeWrapper];
  buildInputs = [jre];

  installPhase = ''
    mkdir -p $out/share/lib/${pname}-${version}
    cp $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
      --add-flags "-jar $out/share/lib/${pname}-${version}/${pname}-${version}.jar"
  '';

  meta = with lib; {
    homepage = "http://www.seleniumhq.org/";
    sourceProvenance = with sourceTypes; [binaryBytecode];
    license = licenses.asl20;
    description = "Selenium Server for remote WebDriver";
    platforms = platforms.all;
  };
}
