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
Feature: Registration at the Fedmaster

  @TCID:FEDM_REGISTRATION_001
  @Approval
  @MODUS:Manuell
  @PRIO:2
  Scenario: Fedmaster Registration - Gutfall - sektoraler IDP

  ```
  Wir durchlaufen den organisatorischen Prozess der Registrierung eines sektoralen IDPs beim Fedmaster

  Als Resultat muss für den registrierten IDP ein EntityStatement mit den entsprechenden Einträgen vorhanden sein.

    Given I have the permission to register an IDP
    When I send an E-Mail to 'idp-registration@gematik.de'
    And I ask for the registration of an IDP with
      | Betriebsumgebung | Teilnehmertyp | Organisationsname | issuer uri                           | uri zum logo | user_type_supported |
      | RU               | IDP           | gemIDP PoC        | https://idpsek.dev.gematik.solutions | empty        | IP                  |
    And I submit my JWT signing key and its kid "puk_idp_sig"
    And I submit my TLS Server's public key and the domain "https://idpsek.dev.gematik.solutions"
    Then I get a confirmation within five days
    When I fetch the Entity Statement for my IDP
    Then the Entity Statement contains the data mentioned above


  @TCID:FEDM_REGISTRATION_002
  @Approval
  @Manuell
  Scenario: Fedmaster Registration - Gutfall - Fachdienst

  ```
  Wir durchlaufen den organisatorischen Prozess der Registrierung eines Fachdienstes beim Fedmaster

  Als Resultat muss für den registrierten Fachdienst ein EntityStatement mit den entsprechenden Einträgen vorhanden sein.

    Given I have the permission to register a Fachdienst
    When I send an E-Mail to 'idp-registration@gematik.de'
    And I ask for the registration of a Fachdienst with
      | Betriebsumgebung | Teilnehmertyp | Organisationsname | issuer uri                            | verlangte scopes                                             |
      | RU               | Fachdienst    | gemFachdienst PoC | https://idpfadi.dev.gematik.solutions | openid urn:telematik:display_name urn:telematik:versicherter |
    And I submit my JWT signing key and its kid "puk_fadi_sig"
    Then I get a confirmation within five days
    When I fetch the Entity Statement for my Fachdienst
    Then the Entity Statement contains the data mentioned above
