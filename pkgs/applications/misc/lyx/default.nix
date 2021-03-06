{ fetchurl, stdenv, pkgconfig, python, file, bc
, qt4, hunspell, makeWrapper #, mythes, boost
}:

stdenv.mkDerivation rec {
  version = "2.1.5";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.1.x/${name}.tar.xz";
    sha256 = "1wrcxsvr5kx8cfdabshzmcjrb3rmy5bh74njnzpq9m5xms8parrf";
  };

  configureFlags = [
    #"--without-included-boost"
    /*  Boost is a huge dependency from which 1.4 MB of libs would be used.
        Using internal boost stuff only increases executable by around 0.2 MB. */
    #"--without-included-mythes" # such a small library isn't worth a separate package
  ];

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  buildInputs = [
    pkgconfig qt4 python file/*for libmagic*/ bc
    hunspell makeWrapper # enchant
  ];

  enableParallelBuilding = true;
  doCheck = true;

  # python is run during runtime to do various tasks
  postFixup = ''
    wrapProgram "$out/bin/lyx" \
      --prefix PATH : '${python}/bin'
  '';

  meta = with stdenv.lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = "http://www.lyx.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}

