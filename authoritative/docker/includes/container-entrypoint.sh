if [[ $DSC_FORMAT_JSON == true ]]
then
  sed -i 's/output_format XML/output_format JSON/g' /etc/dsc/dsc.conf
fi

if [[ $MMDB_ENABLED == true ]]
then
  if [[ $MMDB_LICENSE_KEY == "" ]]
  then
    echo "$MMDB_LICENSE_KEY is empty, MaxMinds Database will fail to download!"
  else
    export MMDB_URL="https://download.maxmind.com/app/geoip_download?license_key=${MMDB_LICENSE_KEY}&edition_id=GeoLite2"
    cd /tmp
    wget "$MMDB_URL-Country&suffix=tar.gz" -O MMDB-Country.tar.gz
    wget "$MMDB_URL-ASN&suffix=tar.gz" -O MMDB-ASN.tar.gz

    cp `find ./GeoLite2-ASN*/*.mmdb` /etc/dsc/ASN.mmdb
    cp `find ./GeoLite2-Country*/*.mmdb` /etc/dsc/Country.mmdb

    sed -i 's/#dataset country_code/dataset country_code/g' /etc/dsc/dsc.conf
    sed -i 's/#dataset asn_all/dataset asn_all/g' /etc/dsc/dsc.conf
    sed -i 's/indexer_backend geoip/indexer_backend maxminddb/g' /etc/dsc/dsc.conf
    sed -i 's/#asn_index/asn_index/g' /etc/dsc/dsc.conf
    sed -i 's/#country_index/country_index/g' /etc/dsc/dsc.conf
    sed -i 's/#maxminddb_asn "\/path\/to\/GeoLite2\/ASN.mmdb"/maxminddb_asn "\/etc\/dsc\/ASN.mmdb"/g' /etc/dsc/dsc.conf
    sed -i 's/#maxminddb_country "\/path\/to\/GeoLite2\/Country.mmdb"/maxminddb_asn "\/etc\/dsc\/Country.mmdb"/g' /etc/dsc/dsc.conf
  fi
fi

/usr/bin/dsc /etc/dsc/dsc.conf
/usr/bin/tini -- /usr/local/sbin/pdns_server-startup