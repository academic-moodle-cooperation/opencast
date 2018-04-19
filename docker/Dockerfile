FROM alpine:3.7

ENV LANG="C.UTF-8" \
    JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
    PATH="$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin" \
    HUNSPELL_BASE_URL="http://download.services.openoffice.org/contrib/dictionaries" \
    \
    OPENCAST_VERSION="4.3" \
    OPENCAST_DISTRIBUTION_CONFIG="docker/" \
    OPENCAST_DISTRIBUTION="allinone" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_DATA="/data" \
    OPENCAST_CUSTOM_CONFIG="/etc/opencast" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800"
ENV OPENCAST_SCRIPTS="${OPENCAST_HOME}/docker/scripts" \
    OPENCAST_SUPPORT="${OPENCAST_HOME}/docker/support" \
    OPENCAST_CONFIG="${OPENCAST_HOME}/etc" \
    OPENCAST_SRC="/usr/src/opencast"

RUN addgroup -S -g "${OPENCAST_GID}" "${OPENCAST_GROUP}" \
 && adduser -S -D -H -G "${OPENCAST_GROUP}" -h "${OPENCAST_HOME}" -u "${OPENCAST_UID}" "${OPENCAST_USER}" \
 && mkdir -p "${OPENCAST_DATA}" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_DATA}"

COPY --chown=opencast:opencast "build/opencast-dist-${OPENCAST_DISTRIBUTION}-*.tar.gz" "${OPENCAST_HOME}/"

RUN cd "${OPENCAST_HOME}" \
    && tar -xzf opencast-dist-${OPENCAST_DISTRIBUTION}-*.tar.gz --strip 1 -C "${OPENCAST_HOME}" \
    && rm -rf opencast-dist-${OPENCAST_DISTRIBUTION}-*.tar.gz

COPY --chown=opencast:opencast ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/scripts "${OPENCAST_SCRIPTS}"
COPY --chown=opencast:opencast ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/support "${OPENCAST_SUPPORT}"
COPY --chown=opencast:opencast ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/etc/ "${OPENCAST_CONFIG}/"
#COPY --chown=opencast:opencast ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/etc/index/adminui/settings.yml "${OPENCAST_CONFIG}/index/adminui/"
#COPY --chown=opencast:opencast ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/etc/index/externalapi/settings.yml "${OPENCAST_CONFIG}/index/externalapi/"
COPY ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/docker-entrypoint.sh  ${OPENCAST_DISTRIBUTION_CONFIG}/${OPENCAST_DISTRIBUTION}/assets/docker-healthcheck.sh /

RUN apk add --no-cache \
      openjdk8 \
      bash su-exec openssl tzdata curl jq \
      fontconfig ttf-dejavu ttf-freefont ttf-liberation ttf-linux-libertine \
      ffmpeg sox hunspell tesseract-ocr \
  \
 && javac "${OPENCAST_SCRIPTS}/TryToConnectToDb.java" \
  \
 && mkdir -p /tmp/hunspell /usr/share/hunspell \
 && { \
      echo "22e217a631977d7b377f8dd22d2bbacd2d36b32765ce13f3474b03a4a97dd700  en_AU.zip"; \
      echo "31fac12a1b520cde686f328d3fa7560f6eba772cddc872197ff842c57a0dc1ea  en_CA.zip"; \
      echo "5869d8bd80eb2eb328ebe36b356348de4ae2acb1db6df39d1717d33f89f63728  en_GB.zip"; \
      echo "6cc717b4de43240595662a2deef5447b06062e82380f5647196f07c9089284fa  en_NZ.zip"; \
      echo "9227f658f182c9cece797352f041a888134765c11bffc91951c010a73187baea  en_US.zip"; \
      echo "090285b721dcaabff51b467123f82a181a6904d187c90bda812c6e5f365ff19a  en_ZA.zip"; \
    } > /tmp/hunspell-sha256sum.txt \
 && cd /tmp/hunspell \
 && for file in $(awk '{print $2}' /tmp/hunspell-sha256sum.txt); do \
      curl -L -o "${file}" "${HUNSPELL_BASE_URL}/${file}"; \
      grep "${file}" /tmp/hunspell-sha256sum.txt | sha256sum -c -; \
      unzip "/tmp/hunspell/${file}"; \
    done \
 && cp *.aff *.dic /usr/share/hunspell \
 && rm -rf /tmp/*

WORKDIR "${OPENCAST_HOME}"

EXPOSE 8080
VOLUME [ "${OPENCAST_DATA}" ]

HEALTHCHECK --timeout=10s CMD /docker-healthcheck.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
