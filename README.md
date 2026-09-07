# meta-helloworld

A lightweight, custom Yocto Project (OpenEmbedded) layer containing a standalone C `helloworld` application recipe tailored for ARM64 (`qemuarm64`) architectures.

This layer is designed for reproducible builds using Yocto Scarthgap.

---

## Repository Structure

```text
meta-custom/
├── conf/
│   └── layer.conf                      # Layer priority and series compatibility configuration
├── recipes-example/
│   └── helloworld/
│       ├── files/
│       │   └── helloworld.c            # C source code
│       └── helloworld_1.0.bb           # BitBake build recipe
└── README.md
```

## Layer Dependencies

* Yocto Release - scarthgap (LTS)
* Core Layer - poky/meta
* Target Architecture - qemuarm64

## Adding to an existing Yocto Environment and building the image

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
