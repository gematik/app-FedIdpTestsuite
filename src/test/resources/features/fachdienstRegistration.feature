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

@Fachdienst
Feature: Test Registration of a Fachdienst

  @TCID:FEDM_FD_REG_001
  @Approval
  Scenario: Fachdienst EntityStatement - Gutfall - Validiere Response

  ```
  Wir rufen das EntityStatement beim Fachdienst ab

  Die HTTP Response muss:

  - den Code 200
  - einen JWS enthalten

    Given TGR clear recorded messages
    When TGR sende eine leere GET Anfrage an "${fit.fachdienstEntityStatementEndpoint}"
    And TGR find first request to path ".*/.well-known/openid-federation"
    Then TGR current response with attribute "$.responseCode" matches "200"
    And TGR current response with attribute "$.header.Content-Type" matches "application/entity-statement+jwt;charset=UTF-8"

  @TCID:FEDM_FD_REG_002
  @Approval
  Scenario: Fachdienst EntityStatement - Gutfall - Validiere Response Header Claims

  ```
  Wir rufen das EntityStatement beim Fachdienst ab

  Der Response Body muss ein JWS mit den folgenden Header Claims sein:

    Given TGR clear recorded messages
    When TGR sende eine leere GET Anfrage an "${fit.fachdienstEntityStatementEndpoint}"
    And TGR find first request to path ".*/.well-known/openid-federation"
    Then TGR current response at "$.body.header" matches as JSON:
            """
          {
          alg:        'ES256',
          kid:        '.*',
          typ:        'entity-statement+jwt'
          }
        """

  @TCID:FEDM_FD_REG_003
  @Approval
  Scenario: Fachdienst EntityStatement - Gutfall - Validiere Response Body Claims

  ```
  Wir rufen das EntityStatement beim Fachdienst ab

  Der Response Body muss ein JWS mit den korrekten Body Claims sein:

    Given TGR clear recorded messages
    When TGR sende eine leere GET Anfrage an "${fit.fachdienstEntityStatementEndpoint}"
    And TGR find first request to path ".*/.well-known/openid-federation"
    Then TGR current response at "$.body.body" matches as JSON:
            """
          {
            iss:                           'http.*',
            sub:                           'http.*',
            iat:                           "${json-unit.ignore}",
            exp:                           "${json-unit.ignore}",
            jwks:                          "${json-unit.ignore}",
            authority_hints:               "${json-unit.ignore}",
            metadata:                      "${json-unit.ignore}",
          }
        """
    And TGR current response with attribute "$.body.body.authority_hints.0" matches "${fit.fedMasterUrl}"

  @TCID:FEDM_FD_REG_004
  @Approval
  Scenario: Fachdienst EntityStatement - Gutfall - Validiere Metadata Body Claim

  ```
  Wir rufen das EntityStatement beim Fachdienst ab

  Der Response Body muss ein JWS sein. Dieser muss einen korrekt aufgebauten Body Claim metadata enthalten

    Given TGR clear recorded messages
    When TGR sende eine leere GET Anfrage an "${fit.fachdienstEntityStatementEndpoint}"
    And TGR find first request to path ".*/.well-known/openid-federation"
    Then TGR current response at "$.body.body.metadata" matches as JSON:
    """
          {
            openid_relying_party:                           "${json-unit.ignore}",
            ____federation_entity:                              "${json-unit.ignore}"
          }
    """
    And TGR current response at "$.body.body.metadata.openid_relying_party" matches as JSON:
    """
          {
            ____signed_jwks_uri:                          'http.*',
            ____jwks:                                     "${json-unit.ignore}",
            ____organization_name:                        '.*',
            client_name:                                  '.*',
            ____logo_uri:                                 'http.*',
            redirect_uris:                                "${json-unit.ignore}",
            response_types:                               ["code"],
            client_registration_types:                    ["automatic"],
            grant_types:                                  ["authorization_code"],
            require_pushed_authorization_requests:        true,
            token_endpoint_auth_method:                   "self_signed_tls_client_auth",
            default_acr_values:                           "${json-unit.ignore}",
            id_token_signed_response_alg:                 "ES256",
            id_token_encrypted_response_alg:              "ECDH-ES",
            id_token_encrypted_response_enc:              "A256GCM",
            scope:                                        "${fit.scope}",
            ____application_type:                         '.*',
            ____contacts:                                 "${json-unit.ignore}",
            ____subject_type:                             "${json-unit.ignore}"
          }
    """


  @TCID:FEDM_FD_REG_005
  @Approval
  Scenario: Fachdienst - Check Registration in Fed Master's Entity Statement

  ```
  Wir rufen das Entity Statement des Fed Masters über den Fachdienst ab und prüfen, ob im jwks ein passender Schlüssel steht

    Given TGR clear recorded messages
    And Fetch Fedmaster Entity statement
    And TGR find first request to path ".*/.well-known/openid-federation"
    And TGR set local variable "federationFetchEndpoint" to "!{rbel:currentResponseAsString('$..federation_fetch_endpoint')}"
    And TGR clear recorded messages
    And TGR sende eine leere GET Anfrage an "${fit.fachdienstEntityStatementEndpoint}"
    And TGR find first request to path ".*"
    And TGR set local variable "idpSigKid" to "!{rbel:currentResponseAsString('$.body.header.kid')}"
    And TGR clear recorded messages
    When Send Get Request to "${federationFetchEndpoint}" with
      | sub               | iss              |
      | fit.fachdienstUrl | fit.fedMasterUrl |
    And TGR find first request to path ".*"
    Then TGR current response at "$.body.body.jwks.keys.[?(@.kid.content == '${idpSigKid}')]" matches as JSON:
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