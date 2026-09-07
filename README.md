# meta-helloworld

A lightweight, custom Yocto Project (OpenEmbedded) layer containing a standalone C `helloworld` application recipe tailored for ARM64 (`qemuarm64`) architectures.

This layer is designed for reproducible builds using Yocto Scarthgap.

This repository provides a **zero-manual-setup-workflow**, running a single Docker container handles cloning, configuration, resource-throttled compilation, and automated execution inside QEMU using user-mode (`slirp`) networking.

---

## Repository Structure

```text
meta-custom/
├── Dockerfile                         # Container spec (Ubuntu 22.04 + Yocto dependencies)
├── docker-compose.yml                 # One-command container orchestrator
├── build_and_run.sh                   # Automated build & QEMU expect execution script
├── conf/
│   └── layer.conf                     # Layer priority and series compatibility configuration
├── recipes-example/
│   └── helloworld/
│       ├── files/
│       │   └── helloworld.c           # C source code
│       └── helloworld_1.0.bb          # BitBake build recipe
└── README.md
```

## Requirements and Host Constraints
* Host Support: macOS (Apple Silicon)
* Host RAM: 8GB
* Software: Docker Desktop

## Automated Build and Execution (using Docker)

This is the primary and recommended way to build and run.

1. Clone the repository.

        git clone https://github.com/abishekbalu/meta-helloworld.git
        cd meta-helloworld


2. Launch the Docker pipeline

        docker compose up --build


#### What happens inside Docker Pipeline

1. **Environment Setup:** Sets up the container to use Ubuntu22.04 OS and spins a new user `developer`

2. **Repository Sync:** Clone `poky` repository (scarthgap release) and registeres the `meta-helloworld` layer.

3. **Compilation:** Builds a core image using bitbake

4. **Verification:** Boots `qemuarm64`, logs in as `root`, executes `helloworld`, prints the output and exits QEMU gracefully.



## Layer Dependencies

* Yocto Release - scarthgap (LTS)
* Core Layer - poky/meta
* Target Architecture - qemuarm64

## Manual Setup (without Docker)

Once you have the poky environemnt configured, follow the below steps:

1. Clone this layer into your poky directory.

        cd /path(to/poky
        git clone https://github.com/abishekbalu/meta-helloworld.git


2. Register the layer with bitbake.

        source oe-init-build-env
        bitbake-layers add-layer ../meta-helloworld



3. Build the complete image

        bitbake core-image-minimal


## Testing in QEMU

Once the core image has been built with helloworld package,

1. Launch QEMU (using slirp user-mode networking to bypass /dev/net/tun permissions)


        runqemu qemuarm64 nographic slirp



2. Login as ==root== (no password).

3. Execute the binary


        helloworld


The output of the executed binary will be as:

![Output Image of the Binary](https://github.com/abishekbalu/meta-helloworld/blob/master/Images/outputImage.png)
