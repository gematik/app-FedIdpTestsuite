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

Feature: Test Fedmaster's Federation Fetch Endpoint

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR set local variable "federationFetchEndpoint" to "!{rbel:currentResponseAsString('$..federation_fetch_endpoint')}"

  @TCID:FEDMASTER_FED_FETCH_001
  @Approval
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere Response

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Die HTTP Response muss:

  - den Code 200
  - den korrekten content-type enthalten

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.header.Content-Type" matches "application/entity-statement+jwt;charset=UTF-8"


  @TCID:FEDMASTER_FED_FETCH_002
  @Approval
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere Response Header Claims

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit den korrekten Header Claims sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    Then TGR current response at "$.body.header" matches as JSON:
    """
          {
          alg:        'ES256',
          kid:        '.*',
          typ:        'entity-statement+jwt'
          }
    """


  @TCID:FEDMASTER_FED_FETCH_003
  @Approval
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere Response Body Claims

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit den korrekten Body Claims sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                           'http.*',
            sub:                           'http.*',
            iat:                           "${json-unit.ignore}",
            exp:                           "${json-unit.ignore}",
            jwks:                          "${json-unit.ignore}",
          }
        """

  @TCID:FEDMASTER_FED_FETCH_004
  @Approval
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere JWKS in Body Claims

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit einem korrekten JWKS Claim sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    Then TGR current response at "$.body.body.jwks.keys.0" matches as JSON:
            """
          {
            ____x5c:                           "${json-unit.ignore}",
            use:                           '.*',
            kid:                           '.*',
            kty:                           'EC',
            crv:                           'P-256',
            x:                             "${json-unit.ignore}",
            y:                             "${json-unit.ignore}",
          }
        """

  @TCID:FEDMASTER_FED_FETCH_005
  @Approval
  Scenario: Federation Fetch Endpoint - Gutfall - Unterstützung des Parameters aud

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Die HTTP Response muss:

  - den Code 200
  - den korrekten content-type enthalten

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub        | iss              | aud               |
      | fit.idpUrl | fit.fedMasterUrl | fit.fachdienstUrl |
    And TGR find request to path ".*"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response at "$.body.body.aud" matches "${fit.fachdienstUrl}"
