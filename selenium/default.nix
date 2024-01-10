{ lib, stdenv, fetchurl, makeWrapper, jre, htmlunit-driver, chromedriver }:

stdenv.mkDerivation rec {
  pname = "selenium-server";
  version = "4.16.0";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/selenium/releases/download/selenium-${version}/selenium-server-${version}.jar";
    sha256 = "sha256-9E5gElR5IWr5Ffq/VY0gdhiG7rSI/xKzRyBNvHD2Rsc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/lib/${pname}-${version}
    cp $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
      --add-flags "-jar $out/share/lib/${pname}-${version}/${pname}-${version}.jar" \
      --prefix PATH : "${chromedriver}/bin" \
      --prefix PATH : "${htmlunit-driver}/bin"
  '';

  meta = {
    homepage = "http://www.seleniumhq.org/";
    description = "Selenium Server for remote WebDriver";
  };
}
