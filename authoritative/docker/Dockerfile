FROM powerdns/pdns-auth-master
USER root
COPY includes/container-entrypoint.sh /container-entrypoint.sh
RUN apt update && apt install -y gnupg2 vim wget
RUN wget -O - https://pkg.dns-oarc.net/dns-oarc.distribution.key.gpg | apt-key add -
RUN echo "deb http://pkg.dns-oarc.net/debian buster main" | tee /etc/apt/sources.list.d/dns-oarc.list
RUN apt update && apt install -y dsc 
RUN mkdir -p /var/lib/dsc
RUN cp /etc/dsc/dsc.conf.sample /etc/dsc/dsc.conf

RUN sed -i 's/#interface eth0/interface eth0/g' /etc/dsc/dsc.conf
RUN sed -i 's/#dataset/dataset/g' /etc/dsc/dsc.conf
RUN sed -i 's/dataset priming_/#dataset priming_/g' /etc/dsc/dsc.conf
RUN sed -i 's/dataset country_code/#dataset country_code/g' /etc/dsc/dsc.conf
RUN sed -i 's/dataset asn_all/#dataset asn_all/g' /etc/dsc/dsc.conf
RUN sed -i 's/#output_format XML/output_format XML/g' /etc/dsc/dsc.conf

ENTRYPOINT ["/bin/bash", "-c", "/container-entrypoint.sh"]