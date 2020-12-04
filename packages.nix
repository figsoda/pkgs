{ pkgs ? import <nixpkgs> { } }:

let self = import ./. (pkgs // self) pkgs; in self
