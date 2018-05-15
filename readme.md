# PowerShell File Converter (Json, Csv, XML)

This is a PowerShell project work for scripting instruction at the HF Juventus. The aim is to reconcile it with the functions of PowerShell.

> "Coming back to where you started is not the same as never leaving."
A Hat Full of Sky

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.
### Prerequisites
To run the code PowerShell must be installed on your computer.

Install PowerShell Introduction:

* [Mac](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-macos?view=powershell-6)
* [Windows](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-windows?view=powershell-6)
* [Linux](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6)

* [Homebrew](https://brew.sh/index_de)

### Installing

A step by step examples for installing the PowerShell File Convert Function.

```
pwsh
. ./fileConverter.ps1
```

## Running the tests

```
pwsh
. ./fileConverter.ps1

Convert-File ./xmlSource.xml csv
Convert-File ./xmlSource.xml json

Convert-File ./jsonSource.xml xml
Convert-File ./jsonSource.xml csv

Convert-File ./csvSource.xml xml
Convert-File ./csvSource.xml json

```

## Built With

* [PowerShell](https://docs.microsoft.com/en-us/powershell/)

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Magister Siltar** - *Initial work* - [MagisterSiltar](https://github.com/MagisterSiltar)
