# MIT License
#
# (C) Copyright [2022] Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

FROM arti.dev.cray.com/baseos-docker-master-local/alpine:3.13 AS build-base

# Copy in code from DMTF's Redfish Interface Emulator project.
COPY --from=artifactory.algol60.net/csm-docker/stable/redfish-interface-emulator:1.0.0-upstream-1.1.7 /usr/src/app /app

# Insert our emulator extentions
COPY src /app
COPY mockups /app/api_emulator/redfish/static
COPY emulator-config.json /app/emulator-config.json

RUN set -ex \
    && apk -U upgrade \
    && apk add --no-cache \
        python3 \
        py3-pip \
        curl \
    && pip3 install --upgrade \
        pip \
        setuptools \
    && pip3 install -r /app/requirements.txt

EXPOSE 5000
WORKDIR /app
ENTRYPOINT ["python3"]
CMD ["emulator.py"]
