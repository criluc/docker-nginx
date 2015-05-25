#!/bin/sh

dpkg-buildpackage -b
cp ../*.deb ../debs/
