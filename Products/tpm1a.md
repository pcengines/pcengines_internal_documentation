# tpm1a

## Usage
See [https://pcengines.github.io/apu2-documentation/tpm_menu/](https://pcengines.github.io/apu2-documentation/tpm_menu/)

## Board compatibility
The tpm1a can be used with

  * apu2

## Upgrading tpm1a firmware

```bash
#!/bin/bash

./TPMFactoryUpd -update tpm20-emptyplatformauth -firmware TPM20_5.61.2785.0_to_TPM20_5.63.3144.0.BIN

```

## Testing tpm1a module
(update script from test-setup)

```bash
#!/bin/bash

./TPMFactoryUpd -info 

```
## Programming the tpm1a module

## Image
![image](https://user-images.githubusercontent.com/18163327/134554757-9f0c7839-5f78-4a8d-ad67-28006a9fbbff.png)

## Schematics
![image](https://user-images.githubusercontent.com/18163327/134555256-a5d446c7-f6f0-4c22-9d95-86398d6b7be1.png)

