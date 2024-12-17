# AFFiNE Monorepo scripts

## Start

```bash
yarn affine -h
```

### Run build command defined in package.json

```bash
yarn affine i18n build
# or
yarn build -p i18n
```

### Run dev command defined in package.json

```bash
yarn affine web dev
# or
yarn dev -p i18n
```

### Clean

```bash
yarn affine clean --ts --dist --rust
# clean node_modules
yarn affine clean --node-modules
```

## Tricks

### Short your key presses

```bash
# af is also available for running the scripts
yarn af web build
```

#### by custom shell script

> personally, I use 'af', and only demoed in macos.

create file `af` in the root of AFFiNE project with the following content

```bash
#!/usr/bin/env sh
./tools/scripts/bin/runner.js affine.ts $@
```

and give it executable permission

```bash
chmod a+x ./af

# now you can run scripts with simply
./af web build
```

if you want to go further, but for vscode(or other forks) only, add the following to your `.vscode/settings.json`

```json
"terminal.integrated.env.osx": {
  "PATH": ".:$PATH"
}
```

restart all the integrated terminals and now you get:

```bash
af web build
```
