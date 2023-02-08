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
Feature: Test Fedmaster's Fed List

  Background: Initialisiere Testkontext durch Abfrage des Entity Statements
    Given Fetch Fedmaster Entity statement
    And TGR find request to path "/.well-known/openid-federation"
    Then TGR set local variable "fedListEndpoint" to "!{rbel:currentResponseAsString('$..federation_list_endpoint')}"

  @TCID:FEDM_FED_LIST_001
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster Fed List - Gutfall - Validiere Response

  ```
  Wir rufen die Fed List beim Fedmaster ab

  Die HTTP Response muss:

  - den Code 200
  - den content-type application/json enthalten

    Given TGR clear recorded messages
    When Send Get Request to "${fedListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.header.Content-Type" matches "application/json;charset=UTF-8"


  @TCID:FEDM_FED_LIST_002
  @Approval
  @PRIO:1
  @TESTSTUFE:4
  Scenario: Fedmaster Fed List - Gutfall - Validiere Response Body

  ```
  Wir rufen die Fed List beim Fedmaster ab

  Die HTTP Response muss die Fed List mit mindestens einer URL als Eintrag im Body enthalten

    Given TGR clear recorded messages
    When Send Get Request to "${fedListEndpoint}"
    And TGR find request to path ".*"
    Then TGR current response at "$.body.0" matches "http.*"
