## [0.4.0](https://github.com/terraform-hc-modules/terraform-hcloud-network/compare/v0.3.3...v0.4.0) (2026-11-13)

### Breaking changes

* hcloud provider floor for the root module, wrappers and `modules/load-balancer` is now `>= 1.70`

### Features

* `modules/load-balancer`: `ipv4_id` / `ipv6_id` (attach existing Primary IPs), `subnet_id` and `network_ip`
* new `modules/firewall-attachment` for `hcloud_firewall_attachment`; root inputs `firewall_server_ids` and `firewall_label_selectors`
* `examples/firewall-attachment`

[#9](https://github.com/terraform-hc-modules/terraform-hcloud-network/pull/9), closes [#8](https://github.com/terraform-hc-modules/terraform-hcloud-network/issues/8)

## [0.3.1](https://github.com/terraform-hc-modules/terraform-hcloud-network/compare/v0.3.0...v0.3.1) (2026-04-20)


### Bug Fixes

* make terraform tests pass in CI ([1d4cce1](https://github.com/terraform-hc-modules/terraform-hcloud-network/commit/1d4cce13cdaf7929366f82c814e5a7809b5c27b3))

# [0.3.0](https://github.com/terraform-hc-modules/terraform-hcloud-network/compare/v0.2.1...v0.3.0) (2026-04-20)


### Features

* add validations, richer outputs, docs, examples and tests ([22c1c64](https://github.com/terraform-hc-modules/terraform-hcloud-network/commit/22c1c64d8c688c202573864ae6459eb1b9e761cf))

## [0.2.1](https://github.com/terraform-hc-modules/terraform-hcloud-network/compare/v0.2.0...v0.2.1) (2026-04-20)


### Bug Fixes

* examples now use root module with source = ../../ ([d8df528](https://github.com/terraform-hc-modules/terraform-hcloud-network/commit/d8df528f51a9c9be57582098c2a011522d626cfd))

# [0.2.0](https://github.com/terraform-hc-modules/terraform-hcloud-network/compare/v0.1.0...v0.2.0) (2026-04-20)


### Features

* add pre-commit, semantic-release, and improve examples ([70c15db](https://github.com/terraform-hc-modules/terraform-hcloud-network/commit/70c15dbd696b4ce946428721c50351b759536985))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-04-20

### Added

- Initial release
- Core module functionality
- Basic and complete examples
- CI/CD with terraform validation, tflint, tfsec, checkov
- Wrappers for for_each usage

[0.1.0]: https://github.com/terraform-hc-modules/terraform-hcloud-network/releases/tag/v0.1.0
