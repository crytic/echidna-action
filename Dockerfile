ARG ECHIDNA_TAG=latest

FROM trailofbits/echidna:$ECHIDNA_TAG
RUN pip3 install solc-select
COPY entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
