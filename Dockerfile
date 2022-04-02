# build stage
#FROM ocaml/opam:ubuntu-ocaml-4.09 as build-stage
FROM ubuntu:20.04 as build-stage
#RUN sudo apt-get install -qq m4 protobuf-compiler pkg-config libcurl4-gnutls-dev libgmp-dev libipc-system-simple-perl libstring-shellquote-perl
#RUN opam install calendars camlp5.8.00.01 cppo dune.2.9.0 jingoo markup ppx_blob ppx_deriving ppx_import stdlib-shims syslog unidecode.0.2.0 uucp uutf uunf
ARG OPAM_PACKAGES="calendars camlp5.8.00.01 cppo dune.2.9.0 jingoo markup ppx_blob ppx_deriving ppx_import stdlib-shims syslog unidecode.0.2.0 uucp uutf uunf"
RUN apt update && apt upgrade -y && apt install -qy gcc make software-properties-common && add-apt-repository ppa:avsm/ppa && apt update && apt install -qy opam libipc-system-simple-perl libstring-shellquote-perl
RUN git clone https://github.com/geneweb/geneweb
WORKDIR geneweb
RUN git checkout tags/Geneweb-ab6b706e
# TODO add option to support multiple config
# ocaml ./configure.ml --sosa-zarith
# ocaml ./configure.ml --api
# etc.
#RUN export PATH=$OPAM_SWITCH_PREFIX/bin/bin/:$PATH && ocaml ./configure.ml --sosa-legacy --gwdb-legacy --release && make distrib
RUN export OPAMYES=1 && opam init --compiler=4.09.1 && eval $(opam config env) && opam update && opam install ${OPAM_PACKAGES} && ocaml ./configure.ml --release && make clean distrib
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
