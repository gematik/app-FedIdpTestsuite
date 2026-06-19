<img align="right" width="200" height="37" src="Gematik_Logo_Flag.png"/> <br/>

# app-FedIdpTestsuite (aka Testsuite Federation Master)

![GitHub Latest Release)](https://img.shields.io/github/v/release/gematik/app-FedIdpTestsuite?label=release&logo=github) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)


<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
       <ul>
        <li><a href="#release-notes">Release Notes</a></li>
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
    <li><a href="#license">License</a></li>
    <li><a href="#additional-notes-and-disclaimer-from-gematik-gmbh">Additional Notes</a></li>
  </ol>
</details>

## About The Project

This project is aimed at manufacturers and providers of a federation master according to
***gemSpec_IDP_FedMaster***.
It includes a test suite that checks whether certain interfaces are implemented according to the
specification.

### Release Notes

See [ReleaseNotes.md](ReleaseNotes.md) for all information regarding the (latest) releases.

## Usage

#### Prerequisites

In order to use the test suite, two files have to be adjusted

* in [tiger-template.yaml](tiger-template.yaml) key `source` expects the address of the Federation Master
* [tc_properties-template.yaml](tc_properties-template.yaml) contains addresses of Federation Master, of a "Fachdienst"
  and of an IDP of the Federation (exactly the values specified as **sub** in Federation
  Fetch Endpoint).

#### Test execution

The test suite is started via the shell script [runTestsuite.sh](runTestsuite.sh). If you want to execute only specific
testcases, the script can be customized to filter for the desired Cucumber tags.

#### Test results

After a successful execution of the test-suite, a test report is generated
at: ```./target/site/serenity/index.html```

## License

Copyright 2021-2026 gematik GmbH

Apache License, Version 2.0

See the [LICENSE](./LICENSE) for the specific language governing permissions and limitations under the License

## Additional Notes and Disclaimer from gematik GmbH

1. Copyright notice: Each published work result is accompanied by an explicit statement of the license conditions for use. These are regularly typical conditions in connection with open source or free software. Programs described/provided/linked here are free software, unless otherwise stated.
2. Permission notice: Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    1. The copyright notice (Item 1) and the permission notice (Item 2) shall be included in all copies or substantial portions of the Software.
    2. The software is provided "as is" without warranty of any kind, either express or implied, including, but not limited to, the warranties of fitness for a particular purpose, merchantability, and/or non-infringement. The authors or copyright holders shall not be liable in any manner whatsoever for any damages or other claims arising from, out of or in connection with the software or the use or other dealings with the software, whether in an action of contract, tort, or otherwise.
    3. The software is the result of research and development activities, therefore not necessarily quality assured and without the character of a liable product. For this reason, gematik does not provide any support or other user assistance (unless otherwise stated in individual cases and without justification of a legal obligation). Furthermore, there is no claim to further development and adaptation of the results to a more current state of the art.
3. Gematik may remove published results temporarily or permanently from the place of publication at any time without prior notice or justification.
4. Please note: Parts of this code may have been generated using AI-supported technology. Please take this into account, especially when troubleshooting, for security analyses and possible adjustments.

## Contact

We take open source license compliance very seriously. We are always striving to achieve compliance
at all times and to improve our processes.
This software is currently being tested to ensure its technical quality and legal compliance. Your
feedback is highly valued.
If you find any issues or have any suggestions or comments, or if you see any other ways in which we
can improve, please open an issue or pull request.