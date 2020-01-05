# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] [1.1.12] :bookmark: - 2020-01-04
### :sparkles: Added
- CPU Temperature color gage
- Contributors to display on the README.MD

### :hammer: Fixed
- Restore terminal color to default after printing the script


## [1.1.11] :bookmark: - 2019-10-05
### :sparkles: Added
- Script automatic analysis and quality checks
- Commentary documentation in code

### :zap: Changed
- Separated the commands from the display to separate the loginc and view

### :hammer: Fixed
- Fix awk division by zero when swap/memory is 0


## [Unreleased] [1.1.10] :bookmark: - 2018-11-01
### :sparkles: Added
- CPU Temperature in degrees Celsius or Farenheit (configurable)


## [1.1.9] :bookmark: - 2018-11-01
### :sparkles: Added
- Top 3 CPU/MEM process with process ID and %
- FQDN hostname
- Open IPv4 Ports
- Open IPv6 Ports

### :zap: Changed
- Moved MOTD.sh to SCRIPT folder
- LAN IP Replace eth0 with an interface from the default route
- Bash scripting conventions review phase I

### :hammer: Fixed
- Uptime display when less than 1 day
- Temperature display when temperature file doesn't exist
- Fixed the HDD usage if using LUKS/LVM


## [1.0.0] :bookmark: - 2018-10-24
### :sparkles: Added:
- :tada: Commit of the initial version
