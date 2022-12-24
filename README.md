# FragPipe Docker

The Dockerfile in this repo can be used to build a container containing FragPipe pre-configured w/ IonQuant and MSFragger


## How to build

```sh
docker build -t JoshCooley/fragpipe .
```

### Build arguments

The following build arguments are optional:
* **`FRAGPIPE_SHA256`**: SHA256 checksum of the FragPipe zip file
* **`FRAGPIPE_VERSION`**: Version of FragPipe to download
* **`IONQUANT_SHA256`**: SHA256 checksum of the IonQuant zip file
* **`IONQUANT_VERSION`**: Version of FragIonQuant to download
* **`MSFRAGGER_SHA256`**: SHA256 checksum of the MSFragger zip file
* **`MSFRAGGER_VERSION`**: Version of MSFragger to download


## How to run

The container supports GUI mode via X-forwarding.

You may also run in headless mode by setting the `HEADLESS` environment variable, mounting your manifest and workflow, and setting their path via the `MANIFEST_FILE` and `WORKFLOW_FILE` variables.

### Environment variables

* **`HEADLESS`**: If set (to any value, including an empty string), FragPipe will start in headless mode. You must also set MANIFEST_FILE and WORKFLOW_FILE variables in headless mode.
* **`MANIFEST_FILE`**: Absolute path to your manifest file. This file must be mounted in the container. This is **not** a path on the host filesystem.
* **`WORKFLOW_FILE`**: Absolute path to your workflow file. This file must be mounted in the container. This is **not** a path on the host filesystem.

### GUI mode

To run in GUI mode, you must allow unauthenticated local connections to the host's X server, mount the X server socket on the container, and set the the `DISPLAY` environment variable.

Grant access to the X server:
```sh
xhost +local:*
```

Run the container with the X server sockets mounted and the `DISPLAY` variable set:
```sh
docker run --rm \
  -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
  -e DISPLAY="$DISPLAY" \
  JoshCooley/fragpipe
```

### Headless mode

To run in headless mode, you will need a workflow and manifest file to mount in the container.
```sh
docker run --rm \
  -e HEADLESS= \
  -e MANIFEST_FILE=/fp-manifest \
  -e WORKFLOW_FILE=/fp-workflow \
  -v /local/path/to/my_manifest.fp-manifest:/fp-manifest \
  -v /local/file/to/my_workflow.fp-workflow:/fp-workflow
```
