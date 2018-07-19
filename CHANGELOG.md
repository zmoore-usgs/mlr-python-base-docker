# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html). (Patch version X.Y.0 is implied if not specified.)

## [Unreleased]
### Added
- kmschoep@usgs.gov - Dockerfile
- kmschoep@usgs.gov - docker-compose.env
- kmschoep@usgs.gov - docker-compose.yml
- kmschoep@usgs.gov - .travis.yml
- isuftin@usgs.gov - python user
- isuftin@usgs.gov - Added curl check in travis to verify http server is running

### Changed
 - isuftin@usgs.gov - Moved lines around in Dockerfile
 - isuftin@usgs.gov - Dockerfile now uses python user instead of root
 - isuftin@usgs.gov - Removed check in travis for a running container
 - isuftin@usgs.gov - Split out config to config.env and secrets.yml
 - isuftin@usgs.gov - docker-compose now mounts certificates into python home dir
