#
# Copyright (Date see Readme), gematik GmbH
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
# *******
#
# For additional notes and disclaimer from gematik and in case of changes by gematik find details in the "Readme" file.
#

@PRODUKT:IDP_FedMaster
Feature: Test Fedmaster's Federation Fetch Endpoint

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find first request to path "/.well-known/openid-federation"
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
    And TGR find first request to path ".*"
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
    And TGR find first request to path ".*"
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
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere Response Body Claims IDP

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit den korrekten Body Claims sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub        | iss              |
      | fit.idpUrl | fit.fedMasterUrl |
    And TGR find first request to path ".*"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                           'http.*',
            sub:                           'http.*',
            iat:                           "${json-unit.ignore}",
            exp:                           "${json-unit.ignore}",
            jwks:                          "${json-unit.ignore}",
            metadata:                      "${json-unit.ignore}"
          }
        """
    Then TGR current response at "$.body.body.metadata.openid_provider" matches as JSON:
                """
          {
            client_registration_types_supported:    ["automatic"]
          }
        """


  @TCID:FEDM_FED_FETCH_004
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere Response Body Claims Relying Party

  ```
  Wir rufen das Entity Statement eines anderen Teilnehmers der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit den korrekten Body Claims sein.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find first request to path ".*"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                           'http.*',
            sub:                           'http.*',
            iat:                           "${json-unit.ignore}",
            exp:                           "${json-unit.ignore}",
            jwks:                          "${json-unit.ignore}",
            metadata:                      "${json-unit.ignore}"
          }
        """
    Then TGR current response at "$.body.body.metadata.openid_relying_party" matches as JSON:
            """
          {
            client_registration_types:    ["automatic"],
            claims:                       [],
            redirect_uris:                "${json-unit.ignore}",
            scope:                        "${json-unit.ignore}"
          }
        """
    And TGR current response with attribute "$.body.body.metadata.openid_relying_party.scope" matches ".*urn:telematik:versicherter.*"
    And TGR current response with attribute "$.body.body.metadata.openid_relying_party.scope" matches ".*openid.*"
    And TGR current response with attribute "$.body.body.metadata.openid_relying_party.redirect_uris" matches ".*https://redirect.testsuite.gsi.*"


  @TCID:FEDM_FED_FETCH_005
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
    And TGR find first request to path ".*"
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

  @TCID:FEDM_FED_FETCH_006
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
    And TGR find first request to path ".*"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.body.body.aud" matches "${fit.fachdienstUrl}"


  @TCID:FEDM_FED_FETCH_007
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
    And TGR find first request to path ".*"
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
    And TGR current response with attribute "$.body.error_description" matches "<error_description>"
    And TGR current response with attribute "$.body.gematik_code" matches "<error_code>"

    Examples: Auth - Fehlende Parameter Beispiele
      | sub        | iss              | error_description                                                    | error_code |
      | invalidSub | fit.fedMasterUrl | Subject .*ist unbekannt                                              | 6011       |
      | fit.idpUrl | invalidIss       | Issuer entspricht nicht dem Entity Identifier des Federation Masters | 6000       |

  @TCID:FEDM_FED_FETCH_008
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  @Monitoring
  Scenario: Federation Fetch Endpoint - Gutfall - Validiere JWKS in Body Claims

  ```
  Wir rufen die Entity Statements der gematik Teilnehmer der Föderation beim Fedmaster ab

  Der Response Body muss ein JWS mit einem JWKS Claim sein.
  Das JWKS muss mindestens einen strukturell korrekten JWK mit use = sig enthalten.

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub        | iss              |
      | fit.idpUrl | fit.fedMasterUrl |
    And TGR find first request to path ".*"
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

    Given TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find first request to path ".*"
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
