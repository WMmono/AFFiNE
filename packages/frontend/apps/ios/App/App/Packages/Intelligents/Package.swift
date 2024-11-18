// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Intelligents",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14),
    .macCatalyst(.v14),
  ],
  products: [
    .library(name: "Intelligents", targets: ["Intelligents"]),
  ],
  targets: [
    .target(name: "Intelligents"),
  ]
)
