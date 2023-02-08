#
# Copyright (c) 2023 gematik GmbH
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
@PRODUKT:IDP_FedMaster
Feature: Test Entity Statement of Fedmaster

  @TCID:FEDM_ENTITY_STATEMENT_001
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster EntityStatement - Gutfall - Validiere Response

  ```
  Wir rufen das EntityStatement beim Fedmaster ab

  Die HTTP Response muss:

  - den Code 200
  - einen JWS enthalten

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.header.Content-Type" matches "application/entity-statement+jwt;charset=UTF-8"


  @TCID:FEDM_ENTITY_STATEMENT_002
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster EntityStatement - Gutfall - Validiere Response Header Claims

  ```
  Wir rufen das EntityStatement beim Fedmaster ab

  Der Response Body muss ein JWS mit den folgenden Header Claims sein:

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response at "$.body.header" matches as JSON:
            """
          {
          alg:        'ES256',
          kid:        '.*',
          typ:        'entity-statement+jwt'
          }
        """

  @TCID:FEDM_ENTITY_STATEMENT_003
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster EntityStatement - Gutfall - Validiere Response Body Claims

  ```
  Wir rufen das EntityStatement beim Fedmaster ab

  Der Response Body muss ein JWS mit den korrekten Body Claims sein:

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                           'http.*',
            sub:                           'http.*',
            iat:                           "${json-unit.ignore}",
            exp:                           "${json-unit.ignore}",
            jwks:                          "${json-unit.ignore}",
            metadata:                      "${json-unit.ignore}",
          }
        """


  @TCID:FEDM_ENTITY_STATEMENT_004
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster EntityStatement - Gutfall - Validiere Metadata Body Claim

  ```
  Wir rufen das EntityStatement beim Fedmaster ab

  Der Response Body muss ein JWS sein. Dieser muss einen korrekt aufgebauten Body Claim metadata enthalten

    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response at "$.body.body.metadata" matches as JSON:
    """
          {
            federation_entity:                           "${json-unit.ignore}"
          }
    """
    And TGR current response at "$.body.body.metadata.federation_entity" matches as JSON:
    """
          {
            federation_fetch_endpoint:                          'http.*',
            federation_list_endpoint:                           'http.*',
            idp_list_endpoint:                                  'http.*'
          }
    """


  @TCID:FEDM_ENTITY_STATEMENT_005
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster EntityStatement - Gutfall - Validiere JWKS in Body Claims

  ```
  Wir rufen das EntityStatement beim Fedmaster ab

  Der Response Body muss ein JWS mit einem JWKS Claim sein.
  Das JWKS muss mindestens einen strukturell korrekten JWK mit use = sig enthalten.


    Given TGR clear recorded messages
    When Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR current response at "$.body.body.jwks.keys.[?($.use.content == 'sig')]" matches as JSON:
            """
          {
            use:                           'sig',
            kid:                           '.*',
            kty:                           'EC',
            crv:                           'P-256',
            x:                             "${json-unit.ignore}",
            y:                             "${json-unit.ignore}",
          }
        """
