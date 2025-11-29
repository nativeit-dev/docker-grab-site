FROM python:3-slim-trixie

# Install system dependencies required for building Python packages
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		git build-essential pkg-config \
		libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
		libsqlite3-dev libffi-dev libxml2-dev libxslt1-dev \
		libre2-dev

# Install grab-site from GitHub (without wpull dependency)
RUN pip3 install --no-cache-dir --upgrade git+https://github.com/nativeit-dev/grab-site@dev-2025

# Install wpull separately with its dependencies (works fine in Linux)
RUN pip3 install --no-cache-dir 'wpull @ https://github.com/ArchiveTeam/ludios_wpull/archive/refs/tags/3.0.9.zip'

# Clean up build dependencies and cache to reduce image size
RUN apt-get purge -y git build-essential pkg-config && \
	apt-get autoremove -y && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

VOLUME /data
WORKDIR /data
EXPOSE 29000
CMD ["python", "/usr/local/bin/gs-server"]
