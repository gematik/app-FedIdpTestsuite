/*
 * Copyright (c) 2023 gematik GmbH
 * 
 * Licensed under the Apache License, Version 2.0 (the License);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package de.gematik.fit.test.steps;

import de.gematik.test.tiger.common.config.TigerGlobalConfiguration;
import io.cucumber.datatable.DataTable;
import io.restassured.specification.RequestSpecification;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import net.serenitybdd.rest.SerenityRest;
import org.springframework.web.util.UriComponentsBuilder;

@Slf4j
public class FedmasterSteps {

  static final String IDP_FEDMASTER_TOP_DOMAIN_URL = "fedmaster";
  static final String ENTITY_STATEMENT_ENDPOINT = "/.well-known/openid-federation";

  public static String replaceHostForTiger(final String url) {
    final UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(url);
    return builder.host(IDP_FEDMASTER_TOP_DOMAIN_URL).port(null).scheme("http").toUriString();
  }

  public void fetchEntStmnt() {
    sendGetRequestTo("http://" + IDP_FEDMASTER_TOP_DOMAIN_URL + ENTITY_STATEMENT_ENDPOINT, null);
  }

  public void sendGetRequestTo(final String url, final DataTable params) {
    final RequestSpecification reqSpec = SerenityRest.rest();
    reqSpec.redirects().follow(false);
    final Optional<String> xAuthHeaderInConfig =
        TigerGlobalConfiguration.readStringOptional("fit.xAuthHeader");
    if (xAuthHeaderInConfig.isPresent()) {
      reqSpec.header("X-Auth", xAuthHeaderInConfig.orElseThrow());
    }
    if (params != null) {
      reqSpec.queryParams(
          params.transpose().cells().stream()
              .collect(
                  Collectors.toMap(
                      ele -> ele.get(0),
                      ele -> TigerGlobalConfiguration.readString(ele.get(1), ele.get(1)))));
    }
    reqSpec.request("GET", url).thenReturn();
  }
}
