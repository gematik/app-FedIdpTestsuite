<img align="right" width="200" height="37" src="Gematik_Logo_Flag.png"/> <br/>

# app-FedIdpTestsuite (aka Testsuite Federation Master)

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
       <ul>
        <li><a href="#releasenotes">Release Notes</a></li>
      </ul>     
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#test-execution">Test execution</a></li>
        <li><a href="#test-results">Test results</a></li>
      </ul>
    </li>
  </ol>
</details>

## About The Project

This project is aimed at manufacturers and providers of a federation master according to
***gemSpec_IDP_FedMaster***.
It includes a test suite that checks whether certain interfaces are implemented according to the
specification.

### Release Notes

See `ReleaseNotes.md` for all information regarding the (newest) releases.

## Usage

#### Prerequisites

In order to use the test suite, two files have to be adjusted

* in `tiger-template.yaml` key `source` expects the address of the Federation Master
* `tc_properties-template.yaml` contains addresses of Federation Master, of a "Fachdienst"
  and of an IDP of the Federation (exactly the values specified as **sub** in Federation
  Fetch Endpoint).

#### Test execution

The test suite is started via shell script `runTestsuite.sh`. Should only be specific
Tests are performed, the script can be customized and filtered to the desired Cucumber tags.

#### Test results

After successful execution of the test-suite, a test report is generated
at: ```./target/site/serenity/index.html```
