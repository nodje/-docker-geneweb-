# build stage
FROM ocaml/opam:ubuntu-ocaml-4.09 as build-stage
RUN sudo apt-get install -qq m4 protobuf-compiler pkg-config libcurl4-gnutls-dev libgmp-dev
#RUN opam install benchmark camlp5 cppo dune.1.11.4 jingoo markup num ounit ocurl piqi piqilib redis redis-sync stdlib-shims unidecode.0.2.0 uucp uutf yojson zarith
#RUN opam install benchmark camlp5 cppo dune.1.11.4 jingoo markup stdlib-shims num unidecode uucp zarith
RUN opam install calendars camlp5.7.12 cppo dune.2.7.1 jingoo markup stdlib-shims syslog unidecode.0.2.0 uucp uutf uunf
RUN git clone https://github.com/geneweb/geneweb
WORKDIR geneweb
RUN git checkout tags/Geneweb-ab6b706e
# TODO add option to support multiple config
# ocaml ./configure.ml --sosa-zarith
# ocaml ./configure.ml --api
# etc.
#RUN export PATH=$OPAM_SWITCH_PREFIX/bin/bin/:$PATH && ocaml ./configure.ml && make distrib
RUN export PATH=/home/opam/.opam/4.09/bin:$PATH && ocaml ./configure.ml --sosa-legacy --gwdb-legacy --release && make clean distrib
# TODO: get rid of hardcoded opam path
# try just `export PATH=$OPAM_SWITCH_PREFIX/bin:$PATH`

# production stage
FROM debian:unstable-slim as production-stage
# This is where your data is
ENV GENEWEBDB   /genewebData
ENV LANGUAGE    fr
ENV FAMILY      lastname
ENV PORT        2317
RUN mkdir -p /home/GW
COPY --from=build-stage /home/opam/geneweb/distribution /home/GW
COPY bootstrap.sh /
RUN chmod a+x /bootstrap.sh

VOLUME ${GENEWEBDB}

EXPOSE 2317
CMD ["/bootstrap.sh"]
