#
# Copyright 2023 gematik GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

@PRODUKT:IDP_FedMaster
Feature: Test Fedmaster's Federation Fetch Endpoint

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR set local variable "federationFetchEndpoint" to "!{rbel:currentResponseAsString('$..federation_fetch_endpoint')}"

  @TCID:FEDM_FED_FETCH_001
  @Approval
  @PRIO:1
  @TESTSTUFE:4
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


  @TCID:FEDM_FED_FETCH_002
  @Approval
  @PRIO:1
  @TESTSTUFE:4
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


  @TCID:FEDM_FED_FETCH_003
  @Approval
  @PRIO:1
  @TESTSTUFE:4
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

  @TCID:FEDM_FED_FETCH_004
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere JWKS in Body Claims

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit einem JWKS Claim sein.
  Das JWKS muss mindestens einen strukturell korrekten JWK mit use = sig enthalten.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find request to path ".*"
    Then TGR current response at "$.body.body.jwks.keys.[?(@.use.content == 'sig')]" matches as JSON:
            """
          {
            use:                           '.*',
            kid:                           '.*',
            kty:                           'EC',
            crv:                           'P-256',
            x:                             "${json-unit.ignore}",
            y:                             "${json-unit.ignore}",
          }
        """

  @OpenBug
  @TCID:FEDM_FED_FETCH_005
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Federation Fetch Endpoint - Gutfall - Unterstützung des Parameters aud

  ```
  Wir rufen als Fachdienst das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

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


  @TCID:FEDM_FED_FETCH_006
    @Approval
    @PRIO:1
    @TESTSTUFE:4
    @TESTFALL:Negativ
  Scenario Outline: Federation Fetch Endpoint - Negativfall - fehlerhaft befüllte Parameter

  ```
  Wir rufen den Federation Fetch Endpoint mit falsch befüllten GET-Parametern auf.

  Der Response Body muss ein JWS mit den korrekten Body Claims sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub   | iss   |
      | <sub> | <iss> |
    And TGR find request to path ".*"
    Then TGR current response at "$.body" matches as JSON:
            """
              {
                "operation": "FETCH",
                "error": "invalid_request",
                "error_description": ".*",
                "gematik_timestamp": "${json-unit.ignore}",
                "gematik_uuid": ".*",
                "gematik_code": ".*"
              }
        """
    And TGR current response at "$.body.error_description" matches "<error_description>"
    And TGR current response at "$.body.gematik_code" matches "<error_code>"

    Examples: Auth - Fehlende Parameter Beispiele
      | sub        | iss              | error_description                                                    | error_code |
      | invalidSub | fit.fedMasterUrl | Subject .*ist unbekannt                                              | 6011       |
      | fit.idpUrl | invalidIss       | Issuer entspricht nicht dem Entity Identifier des Federation Masters | 6000       |