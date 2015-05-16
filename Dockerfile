FROM haskell:7.10

RUN cabal update

ADD dns-verifier.cabal /src/

WORKDIR /src

RUN cabal install --dependencies-only --enable-tests -j4

ADD . /src

EXPOSE 3000

CMD ["cabal", "run"]
