#
# Copyright (c) 2022 gematik GmbH
# 
# Licensed under the Apache License, Version 2.0 (the License);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Feature: Test Signature in JWS

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    And expect JWKS in last message and add its keys to truststore
    And TGR set local variable "idpListEndpoint" to "!{rbel:currentResponseAsString('$..idp_list_endpoint')}"
    And TGR set local variable "federationFetchEndpoint" to "!{rbel:currentResponseAsString('$..federation_fetch_endpoint')}"


  @TCID:FEDMASTER_SIG_001
  @TODO:JWKSmitJexlPruefen
  @TODO:testfallRedundant
  Scenario: Fedmaster Signature - Check kid

  ```
  Wir rufen das Entity Statement des Fedmasters ab und prüfen, ob die kid im Header der kid eines Schlüssels im JWKS im Body entspricht

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response at "$.body.header.kid" matches "!{rbel:currentResponseAsString('$.body.body.jwks.keys.0.kid')}"

  @TCID:FEDMASTER_SIG_002
  Scenario: Fedmaster Signature - Check Entity Statement

  ```
  Wir rufen das Entity Statement des Fedmasters ab und prüfen, ob die Signatur korrekt ist

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    And check signature of JWS in last message


  @TCID:FEDMASTER_SIG_003
  Scenario: Fedmaster Signature - Check IDP List

  ```
  Wir rufen das Entity Statement des Fedmasters ab und prüfen, ob die Signatur korrekt ist

    Given TGR clear recorded messages
    When Send Get Request to "${idpListEndpoint}"
    And TGR find request to path ".*"
    And check signature of JWS in last message


  @TCID:FEDMASTER_SIG_004
  Scenario: Fedmaster Signature - Check Entity Stetement of FD/IDP

  ```
  Wir rufen das Entity Statement des Fedmasters ab und prüfen, ob die Signatur korrekt ist

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    And check signature of JWS in last message
