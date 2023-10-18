USER = amitie10g
all: apt-cacher kali

# Predependencies
apt-cacher:
	@docker run -d \
	-p 3142:3142 \
	--name=apt-cacher-ng \
	-v $$(pwd)/cache:/var/cache/apt-cacher-ng \
	${USER}/apt-cacher-ng

# Depependency building
kali: kali-rolling kali-bleeding-edge

kali-rolling: kali-base kali-desktop kali-headless kali-desktop-plus kali-default

kali-bleeding-edge: kali-bleeding-edge-base kali-bleeding-edge-desktop kali-bleeding-edge-headless kali-bleeding-edge-desktop-plus kali-bleeding-edge-default


# Individual building

# Kali rolling
kali-base:
	@sed \
		-e "s/RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/#RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/g" \
		Dockerfile > Dockerfile.base
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:base -t ${USER}/kali-rolling:base -f Dockerfile.base --push .

kali-desktop:
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:latest -t ${USER}/kali-rolling:latest --push .

kali-headless:
	@sed \
		-e "s/RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/#RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/g" \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		Dockerfile > Dockerfile.headless
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:headless -t ${USER}/kali-rolling:headless -f Dockerfile.headless --push .

kali-desktop-plus:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		Dockerfile > Dockerfile.headless
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:desktop-plus -t ${USER}/kali-rolling:desktop-plus -f Dockerfile.headless --push .

kali-default:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
		Dockerfile > Dockerfile.default
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:default -t ${USER}/kali-rolling:default -f Dockerfile.default --push .

kali-large:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
		-e "s/#RUN apt-get install -y kali-linux-large/RUN apt-get install -y kali-linux-large/g" \
		Dockerfile > Dockerfile.large
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:large -t ${USER}/kali-rolling:large -f Dockerfile.large --push .

kali-full:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
	 	-e "s/#RUN apt-get install -y kali-linux-large/RUN apt-get install -y kali-linux-large/g" \
	 	-e "s/#RUN apt-get install -y kali-linux-everything/RUN apt-get install -y kali-linux-everything/g" \
	Dockerfile > Dockerfile.full
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali:full -t ${USER}/kali-rolling:full -f Dockerfile.full --push .

# Kali bleeding edge
kali-bleeding-edge-base:
	@sed \
		-e "s/RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/#RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/g" \
		Dockerfile > Dockerfile.base
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:base -f Dockerfile.base --push .

kali-bleeding-edge-desktop:
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:latest --push .

kali-bleeding-edge-headless:
	@sed \
		-e "s/RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/#RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10 chromium/g" \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		Dockerfile > Dockerfile.headless
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:headless -f Dockerfile.headless --push .

kali-bleeding-edge-desktop-plus:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		Dockerfile > Dockerfile.headless
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:desktop-plus -f Dockerfile.headless --push .


kali-bleeding-edge-default:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
		Dockerfile > Dockerfile.default
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:default -f Dockerfile.default --push .

kali-bleeding-edge-large:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
		-e "s/#RUN apt-get install -y kali-linux-large/RUN apt-get install -y kali-linux-large/g" \
		Dockerfile > Dockerfile.large
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:large -f Dockerfile.large --push .

kali-bleeding-edge-full:
	@sed \
		-e "s/#RUN apt-get install -y kali-linux-headless/RUN apt-get install -y kali-linux-headless/g" \
		-e "s/#RUN apt-get install -y kali-linux-default/RUN apt-get install -y kali-linux-default/g" \
	 	-e "s/#RUN apt-get install -y kali-linux-large/RUN apt-get install -y kali-linux-large/g" \
	 	-e "s/#RUN apt-get install -y kali-linux-everything/RUN apt-get install -y kali-linux-everything/g" \
	Dockerfile > Dockerfile.full
	@docker buildx build \
	--platform="linux/arm64,linux/armhf,linux/amd64" \
	--build-arg APT_PROXY=$$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng) \
	-t ${USER}/kali-bleeding-edge:full -f Dockerfile.full --push .
