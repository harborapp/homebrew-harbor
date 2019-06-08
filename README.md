# Umschlag: Homebrew

[![Build Status](https://cloud.drone.io/api/badges/umschlag/homebrew-umschlag/status.svg)](https://cloud.drone.io/umschlag/homebrew-umschlag)
[![Join the Matrix chat at https://matrix.to/#/#umschlag:matrix.org](https://img.shields.io/badge/matrix-%23umschlag%3Amatrix.org-7bc9a4.svg)](https://matrix.to/#/#umschlag:matrix.org)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/f0aa1b4da0ab4795bc6092f265648cdd)](https://www.codacy.com/app/umschlag/homebrew-umschlag?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=umschlag/homebrew-umschlag&amp;utm_campaign=Badge_Grade)

**This project is under heavy development, it's not in a working state yet!**

Homebrew repository to install [Umschlag](https://umschlag.tech) on macOS.


## Prepare

```bash
brew tap umschlag/umschlag
```


## Install

### [umschlag-api](https://github.com/umschlag/umschlag-api)

```bash
brew install umschlag-api
umschlag-api -h
```

### [umschlag-ui](https://github.com/umschlag/umschlag-ui)

```bash
brew install umschlag-ui
umschlag-ui -h
```

### [umschlag-cli](https://github.com/umschlag/umschlag-cli)

```bash
brew install umschlag-cli
umschlag-cli -h
```


## Development

```bash
bundle install
bundle exec rake rubocop
bundle exec rake spec
```


## Security

If you find a security issue please contact umschlag@webhippie.de first.


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Thomas Boerger](https://github.com/tboerger)


## License

Apache-2.0


## Copyright

```
Copyright (c) 2018 Thomas Boerger <thomas@webhippie.de>
```
