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
Feature: Test Fedmaster's IDP List

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR set local variable "idpListEndpoint" to "!{rbel:currentResponseAsString('$..idp_list_endpoint')}"

  @TCID:FEDM_IDP_LIST_001
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster IDP List - Gutfall - Validiere Response

  ```
  Wir rufen die IDP List beim Fedmaster ab

  Die HTTP Response muss:

  - den Code 200
  - den content-type application/jwt enthalten

    Given TGR clear recorded messages
    When Send Get Request to "${idpListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.header.Content-Type" matches "application/jwt;charset=UTF-8"


  @TCID:FEDM_IDP_LIST_002
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster IDP List - Gutfall - Validiere Response Header Claims

  ```
  Wir rufen die IDP List beim Fedmaster ab

  Der Response Body muss ein JWS mit den folgenden Header Claims sein:

    Given TGR clear recorded messages
    When Send Get Request to "${idpListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response at "$.body.header" matches as JSON:
            """
          {
          alg:        'ES256',
          kid:        '.*',
          typ:        'idp-list+jwt'
          }
        """

  @TCID:FEDM_IDP_LIST_003
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster IDP List - Gutfall - Validiere Response Body Claims

  ```
  Wir rufen die IDP List beim Fedmaster ab

  Der Response Body muss ein JWS mit den folgenden Body Claims sein:

    Given TGR clear recorded messages
    When Send Get Request to "${idpListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                                 'http.*',
            iat:                                 "${json-unit.ignore}",
            exp:                                 "${json-unit.ignore}",
            idp_entity:                          "${json-unit.ignore}"
          }
        """

  @TCID:FEDM_IDP_LIST_004
  @PRIO:1
  @TESTSTUFE:4
  @Approval
  Scenario: Fedmaster IDP List - Gutfall - Validiere Response Body idp_entity Claim

  ```
  Wir rufen die IDP List beim Fedmaster ab

  Der Response Body muss ein JWS mit einem korrekten idp_entity Body Claim haben:

    Given TGR clear recorded messages
    When Send Get Request to "${idpListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response at "$.body.body.idp_entity.0" matches as JSON:
            """
          {
            organization_name:                    '.*',
            iss:                                  'http.*',
            logo_uri:                             "${json-unit.ignore}",
            user_type_supported:                  '(HP)|(IP)|(HCI)',
          }
        """
